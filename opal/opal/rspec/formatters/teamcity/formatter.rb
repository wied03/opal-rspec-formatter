require 'opal/rspec/formatters/teamcity/debug_logger'

# Since we didn't use the main file, we need to add some missing dependencies
# We can't log to files
SPEC_FORMATTER_LOG = ::Rake::TeamCity::Utils::ConsoleLogger.new(enabled=false)
