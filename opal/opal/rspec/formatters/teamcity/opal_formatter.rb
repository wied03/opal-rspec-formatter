module Opal
  module RSpec
    module Formatters
      # Now that we have a base working formatter, we need to add some PhantomJS related code to exit properly
      class TeamCity < ::Spec::Runner::Formatter::TeamcityFormatter
        ::RSpec::Core::Formatters.register self, :start, :close,
                                           :example_group_started, :example_group_finished,
                                           :example_started, :example_passed,
                                           :example_pending, :example_failed,
                                           :dump_summary, :seed

       # TeamCity doesn't yet identify fluent style examples. In Javascript/Opal, the effect of this is even more pronounced
       # since filenames and line numbers do not mean as much, so waiting to tell TeamCity the example started until it's finished,
       # that way we know the full description - https://youtrack.jetbrains.com/issue/RUBY-15519

       alias_method :orig_example_started, :example_started

       def example_started(notification)
       end

       def example_passed(notification)
         orig_example_started notification
         super
       end

       def example_pending(notification)
         orig_example_started notification
         super
       end

       def example_failed(notification)
         orig_example_started notification
         super
       end
      end
    end
  end
end
