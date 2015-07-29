require 'serverspec_helper'

describe 'selenium::default' do
  if os[:family] == 'windows'
    describe file('C:/ghostdriver/log') do
      it { should be_directory }
    end
  else
    describe file('/usr/local/ghostdriver/log') do
      it { should be_directory }
    end
  end
end
