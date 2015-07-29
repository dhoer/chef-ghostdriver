name 'ghostdriver_test'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description 'Tests GhostDriver'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

depends 'apt'
depends 'yum'
depends 'aws'
depends 'java'
depends 'windows', '~> 1.37.0' # 1.38 spams warning about windows_reboot being removed
depends 'nssm'
depends 'selenium'
depends 'ghostdriver'
