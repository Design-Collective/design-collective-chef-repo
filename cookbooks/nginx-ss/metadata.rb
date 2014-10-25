name             'nginx-ss'
maintainer       'Design Collective'
maintainer_email 'admin@designcollective.io'
license          'All rights reserved'
description      'Installs/Configures nginx-ss'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'


depends "nginx", ">= 2.7.4"
depends "mysql", ">= 5.2.12"
depends "build-essential"
depends "mysql-chef_gem"

%w{ debian ubuntu }.each do |os|
  supports os
end