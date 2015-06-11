# -*- encoding: utf-8 -*-
require File.expand_path('../lib/opal/rspec-formatter/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'opal-rspec-formatter'
  s.version      =  Opal::RSpec::Formatter::VERSION
  s.author       = 'Brady Wied'
  s.email        = 'brady@bswtechconsulting.com'
  s.summary      = 'Allows command line control over Opal-RSpec formatters, includes JUnit formtter'
  s.description  = 'Allows controlling what formatter the opal-rspec Rake task uses'

  s.files = `git ls-files`.split("\n")

  s.require_paths  = ['lib']

  s.add_dependency 'opal', ['>= 0.7.0', '< 0.9']
  s.add_dependency 'opal-builder', '~> 3.2'
  s.add_dependency 'rspec_junit_formatter'
  s.add_development_dependency 'rake'
end
