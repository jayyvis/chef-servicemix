name             'chef-servicemix'
maintainer       'Booz Allen Hamilton'
maintainer_email 'jellyfishopensource@bah.com'
license          'All rights reserved'
description      'Installs/Configures servicemix'
license          'GPL v2'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'
supports         'rhel'

depends "yum"
depends "yum-epel"
depends "iptables"
depends "java"
