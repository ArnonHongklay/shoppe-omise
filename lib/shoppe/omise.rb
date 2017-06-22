require 'shoppe/omise/version'
require 'shoppe/omise/engine'

require 'shoppe/omise/order_extensions'
require 'shoppe/omise/payment_extensions'
module Shoppe
  module Omise
    class << self
      def api_key
        ENV['OMISE_API_KEY'] || Shoppe.settings.omise_api_key
      end

      def publishable_key
        ENV['OMISE_PUBLISHABLE_KEY'] || Shoppe.settings.omise_publishable_key
      end

      def setup
        # Set the configuration which we would like
        Shoppe.add_settings_group :omise, [:omise_api_key, :omise_publishable_key, :omise_currency]

        # Require the external Omise library
        require 'omise'

        # When an order is confirmed, attempt to authorise the payment
        Shoppe::Order.before_confirmation do
          if properties['omise_customer_token'] && total > 0.0
            begin
              charge = ::Omise::Charge.create({ customer: properties['omise_customer_token'], amount: (total * BigDecimal(100)).round, currency: Shoppe.settings.omise_currency, capture: false }, Shoppe::Omise.api_key)
              payments.create(amount: total, method: 'Omise', reference: charge.id, refundable: true, confirmed: false)
            rescue ::Omise::CardError
              raise Shoppe::Errors::PaymentDeclined, 'Payment was declined by the payment processor.'
            end
          end
        end

        # When an order is accepted, attempt to capture the payment
        Shoppe::Order.before_acceptance do
          payments.where(confirmed: false, method: 'Omise').each do |payment|
            begin
              payment.omise_charge.capture
              payment.update_attribute(:confirmed, true)
            rescue ::Omise::CardError
              raise Shoppe::Errors::PaymentDeclined, "Payment ##{payment.id} could not be captured by Omise. Investigate with Omise. Do not accept the order."
            end
          end
        end

        # When an order is rejected, attempt to refund all the payments which have been
        # created with Omise and are not confirmed.
        Shoppe::Order.before_rejection do
          payments.where(confirmed: false, method: 'Omise').each do |payment|
            payment.refund!(payment.refundable_amount)
          end
        end

        # When a new payment is added which is a refund and associated with another Omise method,
        # attempt to refund it automatically.
        Shoppe::Payment.before_create do
          if refund? && parent && parent.method == 'Omise'
            begin
              options = {}
              if parent.confirmed?
                options[:amount] = (amount * BigDecimal(100)).round.abs
              else
                # If the original item hasn't been captured and the amount refunded isn't the
                # same as the orignal value, raise an error.
                if amount.abs != parent.refundable_amount
                  fail Shoppe::Errors::RefundFailed, message: "Refund could not be processed because charge hasn't been captured and the amount is not the same as the original payment."
                end
              end
              refund = parent.omise_charge.refund(options)
              self.method = 'Omise'
              self.reference = refund.id
              true
            rescue ::Omise::CardError, ::Omise::InvalidRequestError => e
              raise Shoppe::Errors::RefundFailed, message: "Refund could not be processed with Omise (#{e.class}: #{e.message}). Please investigate with Omise."
            end
          end
        end
      end
    end
  end
end
