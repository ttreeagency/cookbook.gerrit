#
# Cookbook Name:: gerrit
# Recipe:: gerrit
#
# Copyright 2013, ttree ltd
#

include_recipe 'git'

git "checkout-code" do
    repository "git://github.com/ttreeagency/gerrit-debian.git"
    reference "master"
    action :checkout
    destination "/usr/local/src/gerrit"
end

bash "install_gerrit" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    cd /usr/local/src/gerrit && \
      dpkg-buildpackage -us -uc && \
        sudo dpkg -i ../gerrit_2.5.4_all.deb
  EOH
  not_if { ::File.exists?("/var/lib/gerrit/review_site/bin/gerrit.war") }
end

bash "create_gerrit_admin_user" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
      htpasswd -bc /etc/apache2/gerrit.htpasswd admin admin
      chmod 644 /etc/apache2/gerrit.htpasswd
  EOH
  not_if { ::File.exists?("/etc/apache2/gerrit.htpasswd") }
end

service "gerrit" do
  case node['platform_family']
  when "rhel", "fedora", "suse"
    service_name "gerrit"
    # If restarted/reloaded too quickly httpd has a habit of failing.
    # This may happen with multiple recipes notifying apache to restart - like
    # during the initial bootstrap.
    restart_command "/sbin/service gerrit restart && sleep 1"
    reload_command "/sbin/service gerrit reload && sleep 1"
  when "debian"
    service_name "gerrit"
    restart_command "/usr/sbin/invoke-rc.d gerrit restart && sleep 1"
    reload_command "/usr/sbin/invoke-rc.d gerrit reload && sleep 1"
  when "arch"
    service_name "gerrit"
  when "freebsd"
    service_name "gerrit"
  end
  supports [:restart, :reload, :status]
  action :enable
end

template "/var/lib/gerrit/review_site/etc/gerrit.config" do
  owner "root"
  mode "0644"
  source "gerrit.config.erb"
  notifies :start, "service[gerrit]"
end