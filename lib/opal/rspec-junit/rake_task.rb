require 'opal/rspec/rake_task'

module Opal
  module RspecJunit
    class RakeTask
      include Rake::DSL if defined? Rake::DSL
      
      def initialize(name = 'opal:rspec', &block)
        # We'll add our formatter set code before any main code that uses this task runs. This also should work
        # out of the box with opal-rails, which uses a different server.main util than others
        runner_block = lambda do |server|
          block[server] if block
          run_before_this = server.main
          # TODO: Surely a better way than environment variables to pass this on?          
          ENV['opal_rspec_after_formatter_set'] = run_before_this
          server.main = "opal/rspec/sprockets_runner_junit"
        end
        Opal::RSpec::RakeTask.new name, &runner_block
      end      
    end
  end
end
