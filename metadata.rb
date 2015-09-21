name 'ghostdriver'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description 'Selenium WebDriver for PhantomJS'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.1'

supports 'centos'
supports 'redhat'
supports 'ubuntu'
supports 'windows'

depends 'phantomjs', '~> 1.0'

suggests 'nssm', '~> 1.0'
suggests 'windows', '~> 1.0'

source_url 'https://github.com/dhoer/chef-ghostdriver' if respond_to?(:source_url)
issues_url 'https://github.com/dhoer/chef-ghostdriver/issues' if respond_to?(:issues_url)
