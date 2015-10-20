Bundler::GemHelper.install_tasks

require 'opal/rspec-formatter/rake_task'
require 'rspec/core/rake_task'

Opal::RSpec::RakeTask.new(:raw_specs) do |_, task|
  task.pattern = 'spec/opal/**/*_spec.rb'
end
RSpec::Core::RakeTask.new(:default) do |s|
  s.pattern = 'spec/mri/**/*_spec.rb'
end

# TODO: Create a new Rake task that parses the XML from stdout and writes it to a file
