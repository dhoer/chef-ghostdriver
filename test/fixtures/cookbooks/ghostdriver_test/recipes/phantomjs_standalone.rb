ghostdriver 'ghostdriver_standalone' do
  username 'vagrant' if platform?('windows')
  password 'vagrant' if platform?('windows')
  webdriver 'localhost:8911'
  action :install
end
