# Varnish version to install
default[:olyn_varnish][:repo][:major_version] = 6.1

# Varnish daemon configs
default[:olyn_varnish][:daemon][:config][:storage_method] = 'malloc'
default[:olyn_varnish][:daemon][:config][:malloc_percent] = 33
default[:olyn_varnish][:daemon][:config][:default_ttl] = 3600
default[:olyn_varnish][:daemon][:config][:host] = '0.0.0.0'

# Frontend listener info
default[:olyn_varnish][:frontend][:ports_data_bag_item] = 'varnish'

# Backend listener info
default[:olyn_varnish][:backend][:ports_data_bag_item] = 'www_backend_http'
