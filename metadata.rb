name             'gerrit'
maintainer       'ttree'
maintainer_email 'dfeyer@ttree.ch'
license          'All rights reserved'
description      'Installs/Configures gerrit'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
depends			 "build-essential"
depends			 "git"
depends          "hostname"
depends          "apt"
depends          "dotdeb"
depends          "apache2"
depends          "postfix"