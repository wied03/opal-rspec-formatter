source 'https://rubygems.org'
gemspec

# Remove this once we use an opal-rspec GEM
system 'git submodule update --init; (cd opal-rspec; git submodule update --init)' unless Dir.glob('opal-rspec/**').any?
gem 'opal', git: 'https://github.com/opal/opal.git'
# Until opal-rspec is updated
gem 'opal-rspec', path: 'opal-rspec'

gem 'nokogiri'
gem 'rspec-expectations'
