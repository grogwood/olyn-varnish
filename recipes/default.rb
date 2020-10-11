# Default varnish recipe
include_recipe 'varnish::default'

# Install varnish from the repo
package 'varnish' do
  action :install
  options '--force-yes'
end

# Define the varnish service
service 'varnish' do
  action %i[enable start]
  supports restart: true, reload: false
end

# Load the frontend port data bag item
frontend_port_item = data_bag_item('ports', node[:olyn_varnish][:frontend][:ports_data_bag_item])

# Varnish config
varnish_config 'default' do
  start_on_boot  true
  listen_address node[:olyn_varnish][:daemon][:config][:host]
  listen_port    frontend_port_item[:port]
  storage        node[:olyn_varnish][:daemon][:config][:storage_method]
  malloc_percent node[:olyn_varnish][:daemon][:config][:malloc_percent]
  major_version  node[:olyn_varnish][:repo][:major_version]
  ttl            node[:olyn_varnish][:daemon][:config][:default_ttl]
  parameters(
    feature: '+http2',
    thread_pools: '4',
    thread_pool_min: '5',
    thread_pool_max: '500',
    thread_pool_timeout: '300'
  )
end

# Load information about the current server from the servers data bag
server = data_bag_item('servers', node[:hostname])

# Create our default VCL config file
vcl_template 'default.vcl' do
  source 'default.vcl.erb'
  variables(
    config: {
      http_host:               server[:url]
    },
    backend: {
      host:      node[:olyn_varnish][:daemon][:config][:host],
      port_item: data_bag_item('ports', node[:olyn_varnish][:backend][:ports_data_bag_item])
    },
    regexp: {
      allow_cookie_urls_item:  data_bag_item('varnish_regexp', 'allow_cookie_urls'),
      bypass_cache_urls_item:  data_bag_item('varnish_regexp', 'bypass_cache_urls'),
      no_cache_urls_item:      data_bag_item('varnish_regexp', 'no_cache_urls'),
      pipe_urls_item:          data_bag_item('varnish_regexp', 'pipe_urls'),
      url_parameters_item:     data_bag_item('varnish_regexp', 'url_parameters')
    }
  )
end

# Setup varnish log
varnish_log 'default'

# Setup varnish ncsa
varnish_log 'default_ncsa' do
  log_format 'varnishncsa'
  major_version node[:olyn_varnish][:repo][:major_version]
end
