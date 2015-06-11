require 'rspec_junit_formatter'

class SpecOpalJunitFormatter < ::RSpecJUnitFormatter
  RSpec::Core::Formatters.register self,
      :start,
      :stop,
      :dump_summary
end
