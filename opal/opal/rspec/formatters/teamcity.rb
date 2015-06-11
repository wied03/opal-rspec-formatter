require 'opal/rspec/formatters/teamcity/formatter_initializer'

# Not including teamcity/spec/runner/formatter/teamcity/formatter because the require File.expand... in there trip up Opal, plus
# we're using RSpec 3 anyways

require 'teamcity/spec/runner/formatter/teamcity/rspec3_formatter'
require 'opal/rspec/formatters/teamcity/formatter'
require 'opal/rspec/formatters/teamcity/rspec3_formatter'
require 'opal/rspec/formatters/teamcity/message_factory'
require 'opal/rspec/formatters/teamcity/runner_common'
