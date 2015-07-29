name 'ghostdriver'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description 'Installs/Configures PhantomJS GhostDriver'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.0'

supports 'centos'
supports 'redhat'
supports 'ubuntu'
supports 'windows'

depends 'phantomjs', '~> 1.0'

suggests 'nssm', '~> 1.0'
suggests 'windows', '~> 1.0'
suggests 'selenium', '~> 2.0'
