require_relative 'spec_helper'

describe 'validate_string' do
  after(:each) do
    ENV.delete('STDLIB_LOG_DEPRECATIONS')
  end

  # Checking for deprecation warning
  it 'displays a single deprecation' do
    ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
    expect(scope).to receive(:warning).with(include('This method is deprecated'))
    is_expected.to run.with_params('', '')
  end

  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }

    describe 'valid inputs' do
      it { is_expected.to run.with_params('') }
      it { is_expected.to run.with_params(nil) }
      it { is_expected.to run.with_params('one') }
      it { is_expected.to run.with_params('one', 'two') }
    end

    describe 'invalid inputs' do
      it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, %r{is not a string}) }
      it { is_expected.to run.with_params({}).and_raise_error(Puppet::ParseError, %r{is not a string}) }
      it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{is not a string}) }
      it { is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, %r{is not a string}) }
    end
  end
end
