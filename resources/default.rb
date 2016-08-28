actions :install
default_action :install

attribute :servicename, kind_of: String, name_attribute: true
attribute :webdriver, kind_of: String, default: lazy { node['ghostdriver']['webdriver'] }
attribute :webdriverSeleniumGridHub, kind_of: [String, NilClass],
                                     default: lazy { node['ghostdriver']['webdriverSeleniumGridHub'] }
