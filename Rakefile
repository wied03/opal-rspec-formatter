require 'bundler'
Bundler.require

Bundler::GemHelper.install_tasks

require 'opal/rspec-junit/rake_task'

Opal::RSpec::RakeTask.new(:raw_specs)

task :default do
  output = `SPEC_OPTS="--require opal/spec_opal_junit_formatter --format SpecOpalJunitFormatter" rake raw_specs`
  xml = /<\?xml.*\<\/testsuite\>/m.match(output)
  puts "got xml #{xml}"
end

# TODO: Create a new Rake task that, sets the formatter, extends Opal::RSpec::RakeTask, and parses the XML from stdout and write it to a file
