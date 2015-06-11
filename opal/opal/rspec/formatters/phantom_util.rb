module Opal
  module RSpec
    module Formatters
      module PhantomUtil        
        def finish_phantom(notification)
          if notification.pending_count > 0
            finish_with_code(1)
          elsif notification.failure_count == 0
            finish_with_code(0)          
          else
            finish_with_code(1)
          end
        end
        
        def finish_with_code(code)
          %x{
            if (typeof(phantom) !== "undefined") {
              phantom.exit(code);
            }
            else {
              Opal.global.OPAL_SPEC_CODE = code;
            }
          }
        end
      end
    end
  end
end
