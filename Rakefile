require 'bundler'
Bundler.require

Bundler::GemHelper.install_tasks

require 'opal/rspec/rake_task'

Opal::RSpec::RakeTask.new(:raw_specs) do |s|
  s.main = 'opal/rspec/sprockets_runner_junit'
end

task :default do
  output = `rake raw_specs`
  xml = /<\?xml.*\<\/testsuite\>/m.match(output)
  puts "got xml #{xml}"
end

# TODO: Create a new Rake task that, sets the formatter, extends Opal::RSpec::RakeTask, and parses the XML from stdout and write it to a file
