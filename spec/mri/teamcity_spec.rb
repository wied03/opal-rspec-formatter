require_relative 'spring_support'

describe 'TeamCity', if: Dir.exist?('../teamcity') do
  let(:command) {
    "RUBYLIB='#{load_path}' SPEC_OPTS='#{spec_opts}' rake raw_specs 2>&1"
  }

  subject(:output) { `#{command}` }

  RSpec.shared_context :success_example do
    it 'succeeds' do
      expect(output).to match /##teamcity\[testSuiteFinished/
      expect(output).to_not match /Specs timed out/
    end
  end

  RSpec.shared_context :fail_example do
    it 'fails' do
      expect(output).to match /TeamCity formatter require \(\S+\) supplied, but was not able to find Teamcity classes in Opal paths.*/
      expect(output).to_not match /Specs timed out/
    end
  end

  context 'default' do
    let(:spec_opts) {
      '--require teamcity/spec/runner/formatter/teamcity/formatter --format Spec::Runner::Formatter::TeamcityFormatter'
    }

    context 'found' do
      let(:load_path) { '../teamcity/patch/common:../teamcity/patch/bdd' }

      include_context :success_example
    end

    context 'not found' do
      let(:load_path) { '../teamcity/patch_foo/common:../teamcity/patch/bdd_foo' }

      include_context :fail_example
    end

    context 'spring' do
      include_context :spring
      # inside test_app
      let(:load_path) { '../../teamcity/patch/common:../../teamcity/patch/bdd' }
      let(:env_vars) {
        {
            'SPEC_OPTS' => spec_opts,
            'RUBYLIB' => load_path
        }
      }

      it { is_expected.to match /##teamcity\[testSuiteFinished/ }
    end
  end

  context 'custom append exp settings' do
    before do
      FileUtils.mv '../teamcity/patch/bdd', '../teamcity/patch/foo_bdd'
      FileUtils.mv '../teamcity/patch/common', '../teamcity/patch/foo_common'
    end

    after do
      FileUtils.mv '../teamcity/patch/foo_bdd', '../teamcity/patch/bdd'
      FileUtils.mv '../teamcity/patch/foo_common', '../teamcity/patch/common'
    end

    let(:load_path) { '../teamcity/patch/foo_common:../teamcity/patch/foo_bdd' }

    context 'found' do
      let(:spec_opts) {
        '--append_exp_from_load_path patch/foo_bdd --append_exp_from_load_path patch/foo_common --require teamcity/spec/runner/formatter/teamcity/formatter --format Spec::Runner::Formatter::TeamcityFormatter'
      }

      include_context :success_example
    end

    context 'not found' do
      let(:spec_opts) {
        '--append_exp_from_load_path patch/bdd_2 --append_exp_from_load_path patch/common_2 --require teamcity/spec/runner/formatter/teamcity/formatter --format Spec::Runner::Formatter::TeamcityFormatter'
      }

      include_context :fail_example
    end
  end
end
