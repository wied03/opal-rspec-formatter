describe 'TeamCity', skip: 'No TeamCity on Travis' do
  before :all do
    raise "Ensure you've copied the /Applications/RubyMine.app/Contents/rb/testing directory to ../teamcity before running" unless Dir.exist?('../teamcity')
  end
  
  let(:command) {
    "RUBYLIB='#{load_path}' SPEC_OPTS='#{spec_opts}' rake raw_specs"
  }
  
  subject {
    `#{command}`
  }
  
  RSpec.shared_context :example do
    it { is_expected.to match /##teamcity\[testSuiteFinished/ }
  end  
  
  context 'default' do    
    let(:spec_opts) {
      '--require teamcity/spec/runner/formatter/teamcity/formatter --format Spec::Runner::Formatter::TeamcityFormatter'
    }
        
    context 'found' do
      let(:load_path) { '../teamcity/patch/common:../teamcity/patch/bdd' }
      
      include_context :example
    end
    
    xcontext 'not found' do
      let(:load_path) { '../teamcity/patch_foo/common:../teamcity/patch/bdd_foo' }
      
      it { is_expected.to match /TeamCity formatter supplied, but was not able to find Teamcity classes in load path/ }
    end
  end
  
  xcontext 'custom append exp settings' do
    before do
      FileUtils.mv '../teamcity/patch/bdd', '../teamcity/patch/bdd_foo'
      FileUtils.mv '../teamcity/patch/common', '../teamcity/patch/common_foo'
    end
    
    after do
      FileUtils.mv '../teamcity/patch/bdd_foo', '../teamcity/patch/bdd'
      FileUtils.mv '../teamcity/patch/common_foo', '../teamcity/patch/common'
    end
    
    let(:load_path) { '../teamcity/patch/common_foo:../teamcity/patch/bdd_foo' }
    
    context 'found' do
      let(:spec_opts) {
        '--append_exp_from_load_path patch/bdd_foo --append_exp_from_load_path patch/common_foo --require teamcity/spec/runner/formatter/teamcity/formatter --format Spec::Runner::Formatter::TeamcityFormatter'
      } 
      
      include_context :example
    end
    
    context 'not found' do
      let(:spec_opts) {
        '--append_exp_from_load_path patch/bdd_2 --append_exp_from_load_path patch/common_2 --require teamcity/spec/runner/formatter/teamcity/formatter --format Spec::Runner::Formatter::TeamcityFormatter'
      }
      
      it { is_expected.to match /TeamCity formatter supplied, but was not able to find Teamcity classes in load path/ }
    end
  end  
end
