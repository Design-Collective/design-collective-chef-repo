#
# Cookbook Name:: nginx-ss
# Recipe:: default
#
# Copyright 2014, Design Collective
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nginx-ss"
include_recipe "mysql::server"
include_recipe "mysql-chef_gem"
include_recipe "php"
include_recipe "php::module_mysql"

package 'nginx' do
  action :install
end

service 'nginx' do
  action [ :enable, :start ]
end

cookbook_file "/srv/www/test.php" do
  source "test.php"
  mode "0644"
end

nginx_site '#{node.app.name}' do
  host 'salvame.designcollective.io'
  root '/srv/www/fundacionsalvame'
end

template "#{node.nginx.dir}/sites-available/#{node.app.name}.conf" do
  source "nginx.conf.erb"
  mode "0644"
end

#if node.has_key?("ec2")
#  server_fqdn = node['ec2']['public_hostname']
#else
#  server_fqdn = node['fqdn']
#end

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['silverstripe']['db']['password'] = secure_password

execute "apt-get update" do
  command "sudo apt-get update"
end

execute "apt-get install git" do
  command "sudo /usr/bin/apt-get install git"
end

#execute "Remove Default Index.html" do
#  cwd node['silverstripe']['parent_dir']
#  command "sudo rm #{node['silverstripe']['parent_dir']}/index.html"
#  only_if {::File.exists?("#{node['silverstripe']['parent_dir']}/index.html")}
#end

#execute "mysql-install-wp-privileges" do
#  command "/usr/bin/mysql -u root -p\"#{node['mysql']['server_root_password']}\" < #{node['mysql']['conf_dir']}/wp-grants.sql"
#  action :nothing
#end

template "#{node['mysql']['conf_dir']}/ss-grants.sql" do
  source "grants.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :user     => node['silverstripe']['db']['user'],
    :password => node['silverstripe']['db']['password'],
    :database => node['silverstripe']['db']['database']
  )
  notifies :run, "execute[mysql-install-wp-privileges]", :immediately
end

execute "create #{node['silverstripe']['db']['database']} database" do
  command "/usr/bin/mysqladmin -u root -p\"#{node['mysql']['server_root_password']}\" create #{node['silverstripe']['db']['database']}"
  not_if do
    # Make sure gem is detected if it was just installed earlier in this recipe
    require 'rubygems'
    Gem.clear_paths
    require 'mysql'
    m = Mysql.new("localhost", "root", node['mysql']['server_root_password'])
    m.list_dbs.include?(node['silverstripe']['db']['database'])
  end
  notifies :create, "ruby_block[save node data]", :immediately unless Chef::Config[:solo]
end

# save node data after writing the MYSQL root password, so that a failed chef-client run that gets this far doesn't cause an unknown password to get applied to the box without being saved in the node data.
unless Chef::Config[:solo]
  ruby_block "save node data" do
    block do
      node.save
    end
    action :create
  end
end

log "silverstripe_install_message" do
  action :nothing
  message "Navigate to 'http://#{server_fqdn}/install.php' to complete SilverStripe installation"
end

template "#{node['silverstripe']['parent_dir']}/shared/mysite/_db.php" do
  source "_db.php.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :database        => node['silverstripe']['db']['database'],
    :user            => node['silverstripe']['db']['user'],
    :password        => node['silverstripe']['db']['password']
  )
  notifies :write, "log[silverstripe_install_message]"
end

#apache_site "000-default" do
#  enable false
#end

#web_app "silverstripe" do
#  template "silverstripe.conf.erb"
#  docroot node['silverstripe']['parent_dir'] #This needs to be parent_dir, that's where the docroot is. silverstripe is in its folder but callsed into index from one level up.
#  server_name node['silverstripe']['server_name']
#  server_aliases node['silverstripe']['server_aliases']
#  #server_aliases node['silverstripe']['server_port'] #this was breaking the provisioning
#  server_port node['silverstripe']['server_port'] 
#  enable true
#end

execute "set www-data ownership of #{node['silverstripe']['parent_dir']}" do
  command "chown -R www-data:www-data #{node['silverstripe']['parent_dir']}"
end

execute "apt-get update 2" do
  command "sudo apt-get update --fix-missing"
end