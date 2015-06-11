# Since we didn't use the main file, we need to add some missing dependencies

# We can't log to files so just make this a disabled logger
SPEC_FORMATTER_LOG = ::Rake::TeamCity::Utils::FileLogger.new(enabled=false, file_suffix=:does_not_matter)
