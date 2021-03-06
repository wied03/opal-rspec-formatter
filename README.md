# opal-rspec-formatter

[![Build Status](http://img.shields.io/travis/wied03/opal-rspec-formatter/master.svg?style=flat)](http://travis-ci.org/wied03/opal-rspec-formatter)

Make the JUnit and Jetbrains provided TeamCity formatters work with opal-rspec

## Usage

Add `opal-rspec-formatter` to your Gemfile:

```ruby
gem 'opal-rspec-formatter'
```

### Use in your application

#### JUnit

Now on the command line, supply the SPEC_OPTS environment variable. Example:

```bash
SPEC_OPTS="--require opal/rspec/formatters/junit --format Opal::RSpec::Formatters::Junit" rake
```

If you omit either of these settings, the default opal-rspec formatter will be used (TextFormatter)

#### TeamCity

Example:
```bash
# TeamCity/RubyMine will normally add all this for you and all you need to do is run your Rake task within its environment
RUBYLIB="/Applications/RubyMine.app/Contents/rb/testing/patch/bdd:/Applications/RubyMine.app/Contents/rb/testing/patch/common" SPEC_OPTS="--require teamcity/spec/runner/formatter/teamcity/formatter --format Spec::Runner::Formatter::TeamcityFormatter" rake
```

This GEM will look for anything on the load path that matches patch/common or patch/bdd and add it to the Opal path for you. It will also change the formatter class from the stock one (Spec::Runner::Formatter::TeamcityFormatter) to Opal::RSpec::Formatters::TeamCity automatically. If these items change, you can supply 'append_exp_from_load_path' in SPEC_OPTS to specify different expressions for locating the TeamCity/RubyMine files in the load path.

In order to avoid distributing a copy of the TeamCity formatter, we only include the patches here.

#### Custom
This GEM currently includes a JUnit XML formatter and patches to make the TeamCity/Rubymine runner work, but you can use any formatter you can get working with Opal.

## Limitations:

### General
* Tested on Opal 0.8, Opal 0.9/master and a branch of opal-rspec (see Gemfile)
* Right now, the XML is just echo'ed to the console. A wrapper task is planned that will write the XML to a file for you.
* The formatter must be on the Opal load path. If it's not, you'll need to append_paths when you define your Rake task (see opal-rspec info)
* Of the various SPEC_OPTS possibilities RSpec supports, only --require and --format are supported with this GEM

### TeamCity
* Does not support output capturing
* Tweaks how example start/finish reporting works in order to work better with implicit subjects (see https://youtrack.jetbrains.com/issue/RUBY-15519). The side effect is that although test durations will be correct, the test start event is not reported until the test finishes.

## Contributing

Install required gems at required versions:

    $ bundle install

A simple rake task should run the example specs in `spec/`:

    $ bundle exec rake

## License

Authors: Brady Wied

Copyright (c) 2015, BSW Technology Consulting LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

TeamCity and RubyMine are Copyright 2000-2015 JetBrains s.r.o
