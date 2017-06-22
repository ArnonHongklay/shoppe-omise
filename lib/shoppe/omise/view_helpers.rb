module Shoppe
  module Omise
    module ViewHelpers
      def shoppe_omise_javascript
        ''.tap do |s|
          s << javascript_include_tag('https://js.omise.com/v2/')
          s << "<script type=\"text/javascript\">Omise.setPublishableKey('#{Shoppe::Omise.publishable_key}');</script>"
        end.html_safe
      end
    end
  end
end
