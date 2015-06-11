require 'opal/rspec/formatters/phantom_util'

module Opal
  module RSpec
    module Formatters
      # Now that we have a base working formatter, we need to add some PhantomJS related code to exit properly
      class TeamCity < ::Spec::Runner::Formatter::TeamcityFormatter
        include Opal::RSpec::Formatters::PhantomUtil
        
        ::RSpec::Core::Formatters.register self, :start, :close,
                                           :example_group_started, :example_group_finished,
                                           :example_started, :example_passed,
                                           :example_pending, :example_failed,
                                           :dump_summary, :seed
                                           
       def dump_summary(notification)
         super
         finish_phantom notification
       end
      end
    end
  end
end
