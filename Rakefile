require 'bundler'
Bundler.require

Bundler::GemHelper.install_tasks

require 'opal/rspec-formatter/rake_task'

Opal::RSpec::RakeTask.new(:raw_specs)

task :default do
  output = `SPEC_OPTS="--require opal/rspec/formatters/junit --format Opal::RSpec::Formatters::Junit" rake raw_specs`
  xml = /<\?xml.*\<\/testsuite\>/m.match(output)
  puts "got xml #{xml}"
end

# TODO: Create a new Rake task that parses the XML from stdout and writes it to a file
