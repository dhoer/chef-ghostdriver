ghostdriver 'ghostdriver_seleniumnode' do
  webdriver "#{node['ipaddress']}:8911"
  webdriverSeleniumGridHub "http://#{node['ipaddress']}:4444/grid/register/"
  action :install
end
