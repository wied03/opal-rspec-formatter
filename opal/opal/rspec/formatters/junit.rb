require 'rspec_junit_formatter'

module Opal
  module RSpec
    module Formatters
      class Junit < ::RSpecJUnitFormatter
        ::RSpec::Core::Formatters.register self,
            :start,
            :stop,
            :dump_summary
            
        def initialize
          # with console output, new lines will be all over the place
          super output=StringIO.new
        end
      
        def dump_summary(notification)
          @summary_notification = notification
          xml_dump
          puts '---begin xml---'
          puts output.string
          puts '---end xml---'
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
