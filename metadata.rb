name 'olyn_varnish'
maintainer 'Scott Richardson'
maintainer_email 'dev@grogwood.com'
chef_version '~> 15'
license 'GPL-3.0'
supports 'debian', '>= 10'
source_url 'https://gitlab.com/olyn/olyn_varnish'
description 'Installs and configures the Varnish HTTP cache'
version '1.0.0'

provides 'olyn_varnish::default'
recipe 'olyn_varnish::default', 'Installs Varnish HTTP cache'

depends 'varnish', '~> 4'