actions :install
default_action :install

attribute :name, kind_of: String, name_attribute: true
attribute :webdriver, kind_of: String, default: node['ghostdriver']['webdriver']
attribute :webdriverSeleniumGridHub,
          kind_of: [String, NilClass],
          default: node['ghostdriver']['webdriverSeleniumGridHub']

# windows only - set username/password to run service in gui or leave nil to run service in background
attribute :domain, kind_of: String, default: node['ghostdriver']['domain']
attribute :username, kind_of: String, default: node['ghostdriver']['username']
attribute :password, kind_of: String, default: node['ghostdriver']['password']
