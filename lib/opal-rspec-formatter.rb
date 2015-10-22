require 'opal'
require 'opal-builder'
require 'opal/rspec-formatter/tc_pre_rack_locator'

Opal.append_path File.expand_path('../../opal', __FILE__).untaint
# Not using use_gem because we don't want the RSpec dependencies rspec_junit_formatter has
junit = Gem::Specification.find_by_name('rspec_junit_formatter')
Opal.append_path File.join(junit.gem_dir, 'lib')
