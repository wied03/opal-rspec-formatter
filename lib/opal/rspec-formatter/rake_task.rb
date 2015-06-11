require 'opal/rspec/rake_task'

class Opal::RSpec::RakeTask
  # Monkey patching the constructor without duplicating it here
  alias_method :orig_init, :initialize
  
  def self.get_requires
    spec_opts = ENV['SPEC_OPTS']
    return [] unless spec_opts
    spec_opts.scan(/--require (\S+)/).flatten
  end
  
  def get_custom_load_path_expressions
    spec_opts = ENV['SPEC_OPTS']
    return [] unless spec_opts
    matches = spec_opts.scan /--append_exp_from_load_path (\S+)/
    matches.flatten.map {|m| Regexp.new(Regexp.escape(m))}
  end
  
  def add_to_load_path(expressions, server)
    expressions.each do |r|      
      matches = $:.select {|path| r.match(path)}
      matches.each do |load_path|
        puts "Adding #{load_path} to Opal path"
        server.append_path load_path
      end
    end
  end
  
  def get_default_teamcity_load_path_expressions
    [/patch\/bdd/, /patch\/common/]
  end
  
  def teamcity_require_indicator
    'teamcity/spec/runner/formatter/teamcity/formatter'
  end
  
  def is_teamcity
    Opal::RSpec::RakeTask.get_requires.include? teamcity_require_indicator
  end
  
  def validate_teamcity_is_there(server)
    filename = teamcity_require_indicator+'.rb'
    paths = server.sprockets.paths
    found = paths.find {|p| File.exist?(File.join(p, filename))}
    unless found
      raise "Searched #{Opal.paths} for #{filename} but was not able to find it!"
    end
  end
  
  def initialize(name = 'opal:rspec', &block)
    # We'll add our formatter set code before any main code that uses this task runs. This also should work
    # out of the box with opal-rails, which uses a different server.main util than others
    runner_block = lambda do |server|
      block[server] if block
      run_before_this = server.main
      # TODO: Surely a better way than environment variables to pass this on?          
      ENV['opal_rspec_after_formatter_set'] = run_before_this
      server.main = 'opal/rspec/sprockets_runner_customformat'
      
      add_to_load_path get_custom_load_path_expressions, server
      if is_teamcity        
        add_to_load_path get_default_teamcity_load_path_expressions, server
        validate_teamcity_is_there server
      end
    end
    
    orig_init name, &runner_block
  end      
end
