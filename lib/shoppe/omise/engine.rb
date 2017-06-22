module Shoppe
  module Omise
    class Engine < Rails::Engine
      initializer 'shoppe.omise.initializer' do
        Shoppe::Omise.setup
        ActiveSupport.on_load(:action_view) do
          require 'shoppe/omise/view_helpers'
          ActionView::Base.send :include, Shoppe::Omise::ViewHelpers
        end
      end

      config.to_prepare do
        Shoppe::Order.send :include, Shoppe::Omise::OrderExtensions
        Shoppe::Payment.send :include, Shoppe::Omise::PaymentExtensions
      end
    end
  end
end
