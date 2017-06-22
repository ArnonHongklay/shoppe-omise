module Shoppe
  module Omise
    module PaymentExtensions
      def omise_charge
        return false unless method == 'Omise'
        @omise_charge ||= ::Omise::Charge.retrieve(reference, Shoppe::Omise.api_key)
      end

      def transaction_url
        "https://manage.omise.com/#{Rails.env.production? ? '/' : 'test/'}payments/#{reference}"
      end
    end
  end
end
