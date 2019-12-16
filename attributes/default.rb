# Storage
default[:olyn_varnish][:storage_method] = 'malloc'
default[:olyn_varnish][:malloc_percent] = 33

# Default host
default[:olyn_varnish][:host] = '0.0.0.0'

# Frontend listener info
default[:olyn_varnish][:frontend_ports_data_bag_item] = 'varnish'

# Backend info
default[:olyn_varnish][:backend_ports_data_bag_item] = 'www'

# Varnish version
default[:olyn_varnish][:major_version] = 6.1