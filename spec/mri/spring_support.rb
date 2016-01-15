require 'tempfile'

RSpec.shared_context :spring do
  before :all do
    Dir.chdir 'test_app' do
      output = Bundler.with_clean_env do
        `bundle install`
      end
      puts output
      raise unless $?.success?
    end
  end
  let(:env_vars) {
    {
        'SPEC_OPTS' => spec_opts
    }
  }
  # Spring seems goofy unless we use File I/O
  def run_stuff(command)
    file = Tempfile.new 'spring_test'
    file.close
    begin
      env_flat = env_vars.map { |k, v| "#{k}='#{v}'" }.join ' '
      redir = "#{env_flat} #{command} 1> #{file.path} 2>&1"
      success = Bundler.clean_system redir
      output = File.read(file.path)
      raise "'#{command}' failed with output\n#{output.strip}" unless success
      output
    ensure
      file.unlink
    end
  end

  def run_spring(command)
    run_stuff "bin/spring #{command}"
  end

  around do |ex|
    Dir.chdir 'test_app' do
      ex.run
    end
  end

  def stop_spring_regardless
    begin
      run_spring 'stop'
    rescue RuntimeError
      # don't care if not running
    end
  end

  before do
    stop_spring_regardless
  end

  after do
    stop_spring_regardless
  end

  subject(:output) {
    run_spring 'opal-rspec'
  }
end
