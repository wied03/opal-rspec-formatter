require 'opal'
require 'opal-builder'

Opal.append_path File.expand_path('../../opal', __FILE__).untaint
# Not using use_gem because we don't want the RSpec dependencies rspec_junit_formatter has
Opal.append_path '/usr/local/bundle/gems/rspec_junit_formatter-0.2.3/lib'
