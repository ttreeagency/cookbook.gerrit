#
# Cookbook Name:: gerrit
# Recipe:: webserver
#
# Copyright 2013, ttree ltd
#

app_name = 'gerrit'
app_config = node[app_name]

include_recipe "apache2"
include_recipe "apache2::mod_rewrite" 
include_recipe "apache2::mod_proxy" 
include_recipe "apache2::mod_proxy_http" 

# Set up the Apache virtual host 
web_app app_name do 
  server_name app_config['server_name']
  doc_root app_config['doc_root']

  template "#{app_name}.conf.erb" 

  log_dir node['apache']['log_dir'] 
end

template "/var/www/index.html" do
  owner "root"
  mode "0644"
  source "index.html.erb"
end

# Disable default vhosts
apache_site "default" do
  notifies :reload, "service[apache2]"
  enable false
end

service "apache2" do
  action :enable
end