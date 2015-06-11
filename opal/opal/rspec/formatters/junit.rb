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
        
        # def xml_dump
#           xml.instruct!
#           # Don't have environment variables here, so just opal-rspec for now
#           xml.testsuite name: "opal-rspec", tests: example_count, failures: failure_count, errors: 0, time: "%.6f" % duration, timestamp: started.iso8601 do
#             xml.comment! "Randomized with seed #{RSpec.configuration.seed}"
#             xml.properties
#             xml_dump_examples
#           end
#         end

        # class name based on filename is not that meaningful in the JS world
        def classname_for(notification)
          group = notification.example.example_group
          # Don't need to show the top level/example group
          show = group.parent_groups.reject {|g| g == ::RSpec::Core::ExampleGroup}
          show.reverse.map {|g| g.description}.join '::'
        end
        
        # Since we include most of the description under classname, only need stuff for this example here
        def description_for(notification)
          notification.example.description
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
