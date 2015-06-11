# opal-rspec-formatter

[![Build Status](http://img.shields.io/travis/wied03/opal-rspec-formatter/master.svg?style=flat)](http://travis-ci.org/wied03/opal-rspec-formatter)

An attempt at making the builder XML gem work with Opal

## Usage

Add `opal-rspec-formatter` to your Gemfile (once this is published to Rubygems, TBD):

```ruby
gem 'opal-rspec-formatter'
```

### Use in your application

If you want to be able to supply a custom formatter from the command line, in your Rakefile, make the following change

```ruby
# Note this require replaces require 'opal/rspec/rake_task'
require 'opal/rspec-formatter/rake_task'
Opal::RSpec::RakeTask.new(:default)
```

This GEM currently includes a JUnit XML formatter, but you can use any formatter you can get working with Opal.

Now on the command line, supply the SPEC_OPTS environment variable. Example:

```bash
SPEC_OPTS="--require opal/rspec/formatters/junit --format Opal::RSpec::Formatters::Junit" rake
```

If you omit either of these settings, the default opal-rspec formatter will be used (TextFormatter)

Limitations:
* This is still under development, so right now, the XML is just echo'ed to the console. A wrapper task is planned that will write the XML to a file for you.
* The formatter must be on the Opal load path. If it's not, you'll need to append_paths when you define your Rake task (see opal-rspec info)
* Of the various SPEC_OPTS possibilities RSpec supports, only --require and --format are supported with this GEM

## Contributing

Install required gems at required versions:

    $ bundle install

A simple rake task should run the example specs in `spec/`:

    $ bundle exec rake

### Run in the browser

Run attached rack app to handle building:

    $ bundle exec rackup

Visit the page in any browser and view the console:

    $ open http://localhost:9292

## License

Authors: Brady Wied

Copyright (c) 2015, BSW Technology Consulting LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
