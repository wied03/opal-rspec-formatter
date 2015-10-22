require 'opal-rspec-formatter'
require 'opal/rspec/rake_task'

class Opal::RSpec::TcPreRackLocator < Opal::RSpec::PreRackLocator
  def get_spec_load_paths
    paths = super
    paths += get_paths_from_expressions(custom_load_path_expressions)
    if is_teamcity
      paths += get_paths_from_expressions(default_teamcity_load_path_expressions)
      validate_teamcity_is_there paths
      existing_spec_opts = ENV['SPEC_OPTS']
      new_spec_ops = existing_spec_opts
                         .gsub(teamcity_require_indicator, 'opal/rspec/formatters/teamcity')
                         .gsub('Spec::Runner::Formatter::TeamcityFormatter', 'Opal::RSpec::Formatters::TeamCity')
      ENV['SPEC_OPTS'] = new_spec_ops
    end
    paths
  end

  private

  def get_spec_opts_requires
    spec_opts = ENV['SPEC_OPTS']
    return [] unless spec_opts
    spec_opts.scan(/--require (\S+)/).flatten
  end

  def custom_load_path_expressions
    spec_opts = ENV['SPEC_OPTS']
    return [] unless spec_opts
    matches = spec_opts.scan /--append_exp_from_load_path (\S+)/
    matches.flatten.map { |m| Regexp.new(Regexp.escape(m)) }
  end

  def get_paths_from_expressions(expressions)
    expressions.map do |exp|
      $:.select { |path| exp.match(path) }
    end.flatten
  end

  def default_teamcity_load_path_expressions
    [/patch\/bdd/, /patch\/common/]
  end

  def teamcity_require_indicator
    'teamcity/spec/runner/formatter/teamcity/formatter'
  end

  def is_teamcity
    get_spec_opts_requires.include? teamcity_require_indicator
  end

  def validate_teamcity_is_there(paths)
    filename = teamcity_require_indicator+'.rb'
    found = paths.find { |p| File.exist?(File.join(p, filename)) }
    unless found
      raise "TeamCity formatter require (#{filename}) supplied, but was not able to find Teamcity classes in Opal paths #{Opal.paths}. By default, anything in the Ruby load path that matches #{default_teamcity_load_path_expressions} will be used. If this needs to be changed, supply -- append_exp_from_load_path in the SPEC_OPTS env variable with another regex."
    end
  end
end

class Opal::RSpec::SprocketsEnvironment
  def initialize(spec_pattern=nil, spec_exclude_pattern=nil, spec_files=nil)
    @locator = Opal::RSpec::TcPreRackLocator.new spec_pattern, spec_exclude_pattern, spec_files
    super()
  end
end
