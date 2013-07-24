#
# Cookbook Name:: gerrit
# Recipe:: default
#
# Copyright 2013, ttree ltd
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'hostname'
include_recipe 'dotdeb'
include_recipe 'build-essential'
include_recipe 'postfix'

node_packages = [ "debhelper", "libssl-dev", "openjdk-6-jdk" ]

node_packages.each do |node_package|
  package node_package do
    action :install
  end
end

bash "create_sshkeys" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
      echo -e "\n\n\n" | ssh-keygen -t rsa -N ""
  EOH
  not_if { ::File.exists?("/root/.ssh/id_rsa.pub") }
end

# Prepare webserver
include_recipe "gerrit::webserver"

# Prepare gerrit
include_recipe "gerrit::gerrit"

