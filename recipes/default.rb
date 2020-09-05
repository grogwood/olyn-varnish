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
frontend_port_item = data_bag_item('ports', node[:olyn_varnish][:frontend_ports_data_bag_item])

# Varnish config
varnish_config 'default' do
  start_on_boot true
  listen_address node[:olyn_varnish][:host]
  listen_port frontend_port_item[:port]
  storage node[:olyn_varnish][:storage_method]
  malloc_percent node[:olyn_varnish][:malloc_percent]
  major_version node[:olyn_varnish][:major_version]
end

# Load information about the current server from the servers data bag
server = data_bag_item('servers', node[:hostname])

# Create our default VCL config file
vcl_template 'default.vcl' do
  source 'default.vcl.erb'
  variables(
    backend_port_item: data_bag_item('ports', node[:olyn_varnish][:backend_ports_data_bag_item]),
    http_host:         server[:url],
    bypass_urls:       data_bag_item('varnish_regexp', 'bypass_urls'),
    cookie_urls:       data_bag_item('varnish_regexp', 'cookie_urls'),
    pipe_urls:         data_bag_item('varnish_regexp', 'pipe_urls'),
    url_parameters:    data_bag_item('varnish_regexp', 'url_parameters')
  )
end

# Setup varnish log
varnish_log 'default'

# Setup varnishncsa
varnish_log 'default_ncsa' do
  log_format 'varnishncsa'
  major_version node[:olyn_varnish][:major_version]
end
