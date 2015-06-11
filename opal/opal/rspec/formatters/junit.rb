require 'rspec_junit_formatter'
require 'opal/rspec/formatters/phantom_util'

module Opal
  module RSpec
    module Formatters
      class Junit < ::RSpecJUnitFormatter
        include Opal::RSpec::Formatters::PhantomUtil
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
          finish_phantom notification
        end     

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
      end
    end  
  end
end
