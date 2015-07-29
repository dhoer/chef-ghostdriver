default['ghostdriver']['webdriver'] = "#{node['ipaddress']}:8910"
default['ghostdriver']['webdriverSeleniumGridHub'] = nil

default['ghostdriver']['windows']['home'] = 'C:/ghostdriver'
default['ghostdriver']['windows']['exec'] = 'C:/ProgramData/chocolatey/bin/phantomjs.exe'

default['ghostdriver']['linux']['home'] = '/usr/local/ghostdriver'
default['ghostdriver']['linux']['exec'] = '/usr/local/bin/ghostdriver'
