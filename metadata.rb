name 'ghostdriver'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description 'Selenium WebDriver for PhantomJS'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/dhoer/chef-ghostdriver' if respond_to?(:source_url)
issues_url 'https://github.com/dhoer/chef-ghostdriver/issues' if respond_to?(:issues_url)
version '1.1.0'

supports 'centos'
supports 'redhat'
supports 'ubuntu'
supports 'windows'

depends 'phantomjs2', '~> 1.0'
depends 'nssm', '~> 1.0'
depends 'windows', '~> 1.0'
