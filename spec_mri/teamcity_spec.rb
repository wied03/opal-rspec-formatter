describe 'TeamCity', skip: 'No TeamCity on Travis' do
  let(:command) {
    "RUBYLIB='../teamcity/patch/common:../teamcity/patch/bdd' SPEC_OPTS='#{spec_opts}' rake raw_specs"
  }
  
  subject {
    `#{command}`
  }
  
  RSpec.shared_context :example do
    it { is_expected.to match /##teamcity\[testSuiteFinished/ }
  end
  
  context 'normal run' do
    let(:spec_opts) {
      '--append_exp_from_load_path patch/bdd --append_exp_from_load_path patch/common --require opal/rspec/formatters/teamcity --format Opal::RSpec::Formatters::TeamCity'
    }
    
    include_context :example
  end
  
  context 'TC tries to override the formatter' do
    # TeamCity will try and add its own contents to SPEC_OPTS    
    let(:spec_opts) {
      '--append_exp_from_load_path patch/bdd --append_exp_from_load_path patch/common --require opal/rspec/formatters/teamcity --format Opal::RSpec::Formatters::TeamCity --require teamcity/spec/runner/formatter/teamcity/formatter --format Spec::Runner::Formatter::TeamcityFormatter'
    }
    
    include_context :example
  end
end
