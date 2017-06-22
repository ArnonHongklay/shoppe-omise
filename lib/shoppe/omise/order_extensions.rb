module Shoppe
  module Omise
    module OrderExtensions
      def accept_omise_token(token)
        if token.start_with?('tok')
          customer = ::Omise::Customer.create({ description: "Customer for order #{number}", card: token }, Shoppe::Omise.api_key)
          properties['omise_customer_token'] = customer.id
          save
        elsif token.start_with?('cus') && properties[:omise_customer_token] != token
          properties['omise_customer_token'] = token
          save
        elsif properties['omise_customer_token'] && properties['omise_customer_token'].start_with?('cus')
          true
        else
          false
        end
      end

      private

      def omise_customer
        @omise_customer ||= ::Omise::Customer.retrieve(properties['omise_customer_token'], Shoppe::Omise.api_key)
      end

      def omise_card
        @omise_card ||= omise_customer.cards.last
      end
    end
  end
end
