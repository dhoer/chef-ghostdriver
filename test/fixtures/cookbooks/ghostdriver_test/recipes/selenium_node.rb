ghostdriver 'ghostdriver_selenium_node' do
  webdriver "#{node['ipaddress']}:8911"
  webdriverSeleniumGridHub "http://#{node['ipaddress']}:4444"
  action :install
end
