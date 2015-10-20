require 'nokogiri'

describe 'JUnit' do
  context 'no env variable set' do
    subject do
      `rake raw_specs`
    end

    it { is_expected.to match /2 examples, 1 failure/ }
  end

  context 'env variable supplied' do
    RSpec::Matchers.define :have_xpath do |xpath|
      get_item = lambda do |document|
        results = document.xpath(xpath)
        results = results.map {|r| r.text }
        results.length == 1 ? results[0] : results
      end

      match do |document|
        actual = get_item[document]
        @value.is_a?(Regexp) ? @value.match(actual) : (actual == @value)
      end

      failure_message do |document|
        "Expected #{@value} but got #{get_item[document]}"
      end

      chain :with_value do |value|
        @value = value
      end
    end

    before :context do
      # this is expensive to run!
      output = `SPEC_OPTS="--require opal/rspec/formatters/junit --format Opal::RSpec::Formatters::Junit" rake raw_specs`
      xml = /<\?xml.*\<\/testsuite\>/m.match(output)[0]
      @@parsed = Nokogiri::XML xml do |config|
        config.strict
      end
    end

    subject { @@parsed }

    it { is_expected.to have_xpath('/testsuite/@tests').with_value('2') }
    it { is_expected.to have_xpath('/testsuite/@failures').with_value('1') }
    it { is_expected.to have_xpath('/testsuite/@errors').with_value('0') }
    it { is_expected.to have_xpath('/testsuite/testcase/@classname').with_value(%w{foobar::succeeds foobar::fails}) }
    it { is_expected.to have_xpath('/testsuite/testcase/@name').with_value(['should eq true', 'should eq false']) }
    it { is_expected.to have_xpath('/testsuite/testcase[@classname="foobar::fails"]/failure/@message').with_value(/expected: false.*got: true/m) }
  end
end
