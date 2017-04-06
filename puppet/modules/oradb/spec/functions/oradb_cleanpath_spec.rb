require 'spec_helper'
require 'puppetlabs_spec_helper/puppetlabs_spec/puppet_internals'

describe 'oradb::cleanpath', :type => :puppet_function do

  context 'with valid parameters' do
    it { is_expected.to run.with_params('/u01/app/oracle/../oraInventory').and_return('/u01/app/oraInventory') }
  end

  context 'With invalid parameters' do
    describe 'with wrong number of parameters' do
      it { is_expected.to run.with_params().and_raise_error(ArgumentError, /expects 1 argument/ ) }
      it { is_expected.to run.with_params('a','b').and_raise_error(ArgumentError, /expects 1 argument/ ) }
    end
    describe 'with non string parameter' do
      it { is_expected.to run.with_params(['a']).and_raise_error(ArgumentError, /expects a String value/ ) }
      it { is_expected.to run.with_params(false).and_raise_error(ArgumentError, /expects a String value/ ) }
      it { is_expected.to run.with_params(42).and_raise_error(ArgumentError,    /expects a String value/ ) }
    end
  end
end
