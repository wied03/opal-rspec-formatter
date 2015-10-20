require 'opal-rspec-formatter'
require 'opal/rspec/rake_task'

class Opal::RSpec::RakeTask
  def get_requires
    spec_opts = ENV['SPEC_OPTS']
    return [] unless spec_opts
    spec_opts.scan(/--require (\S+)/).flatten
  end

  def get_custom_load_path_expressions
    spec_opts = ENV['SPEC_OPTS']
    return [] unless spec_opts
    matches = spec_opts.scan /--append_exp_from_load_path (\S+)/
    matches.flatten.map { |m| Regexp.new(Regexp.escape(m)) }
  end

  def add_to_load_path(expressions, server)
    expressions.each do |r|
      matches = $:.select { |path| r.match(path) }
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
    get_requires.include? teamcity_require_indicator
  end

  def validate_teamcity_is_there(server)
    filename = teamcity_require_indicator+'.rb'
    paths = server.sprockets.paths
    found = paths.find { |p| File.exist?(File.join(p, filename)) }
    unless found
      raise "TeamCity formatter require (#{filename}) supplied, but was not able to find Teamcity classes in Opal paths #{Opal.paths}. By default, anything in the Ruby load path that matches #{get_default_teamcity_load_path_expressions} will be used. If this needs to be changed, supply -- append_exp_from_load_path in the SPEC_OPTS env variable with another regex."
    end
  end

  # Monkey patching the constructor without duplicating it here
  alias_method :orig_init, :initialize

  def initialize(name = 'opal:rspec', &block)
    orig_init name do |server, task|
      add_to_load_path get_custom_load_path_expressions, server
      if is_teamcity
        add_to_load_path get_default_teamcity_load_path_expressions, server
        validate_teamcity_is_there server
        existing_spec_opts = ENV['SPEC_OPTS']
        new_spec_ops = existing_spec_opts
                           .gsub(teamcity_require_indicator, 'opal/rspec/formatters/teamcity')
                           .gsub('Spec::Runner::Formatter::TeamcityFormatter', 'Opal::RSpec::Formatters::TeamCity')
        ENV['SPEC_OPTS'] = new_spec_ops
      end
      block.call(server, task) if block
    end
  end
end
