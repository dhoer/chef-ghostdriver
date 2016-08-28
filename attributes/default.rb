default['ghostdriver']['webdriver'] = "#{node['ipaddress']}:8910"
default['ghostdriver']['webdriverSeleniumGridHub'] = nil

default['ghostdriver']['windows']['home'] = "#{ENV['SYSTEMDRIVE']}/ghostdriver"
default['ghostdriver']['windows']['exec'] = "#{node['phantomjs2']['path']}/phantomjs/phantomjs.exe"
default['ghostdriver']['linux']['exec'] = '/usr/local/bin/phantomjs'
