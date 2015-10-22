# -*- encoding: utf-8 -*-
require File.expand_path('../lib/opal/rspec-formatter/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'opal-rspec-formatter'
  s.version      =  Opal::RSpec::Formatter::VERSION
  s.author       = 'Brady Wied'
  s.email        = 'brady@bswtechconsulting.com'
  s.summary      = 'Allows command line control over Opal-RSpec formatters'
  s.description  = 'Allows controlling what formatter the opal-rspec Rake task uses, includes JUnit and TeamCity formtter patches'
  s.homepage     = 'https://github.com/wied03/opal-rspec-formatter'

  s.files = Dir.glob('lib/**/*.rb') + Dir.glob('opal/**/*.rb')

  s.require_paths  = ['lib']

  s.add_dependency 'opal-rspec', '>= 0.5.0.beta2'
  s.add_dependency 'opal-builder', '~> 3.2'
  s.add_dependency 'rspec_junit_formatter'
  s.add_development_dependency 'rake'
end
