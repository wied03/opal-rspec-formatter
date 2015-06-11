require 'opal/rspec/rake_task'

class Opal::RSpec::RakeTask
  # Monkey patching the constructor without duplicating it here
  alias_method :orig_init, :initialize
  
  def initialize(name = 'opal:rspec', &block)
    # We'll add our formatter set code before any main code that uses this task runs. This also should work
    # out of the box with opal-rails, which uses a different server.main util than others
    runner_block = lambda do |server|
      block[server] if block
      run_before_this = server.main
      # TODO: Surely a better way than environment variables to pass this on?          
      ENV['opal_rspec_after_formatter_set'] = run_before_this
      server.main = 'opal/rspec/sprockets_runner_customformat'
    end
    orig_init name, &runner_block
  end      
end
