#
# Cookbook Name:: servicemix
# Recipe:: default
#
# Copyright (C) 2014 Mandeep Bal
#
# All rights reserved - Do Not Redistribute
#

execute "yum clean" do
  command "yum clean all"
  action :run
end

execute "yum update" do
  command "yum update -y"
  action :run
end

include_recipe "yum"
include_recipe "yum-epel"
include_recipe "java"
include_recipe "iptables"

#Install unzip package from yum
package "unzip" do
  action :install
end

#Create servicemix user
user "servicemix" do
  supports :manage_home => true
  comment "user to own and run the Apache Servicemix"
  system true
  home "/home/servicemix"
  shell "/bin/bash"
  action [ :create ]
end

#Create cloudengine directory
directory "/opt/cloudengine/" do
  owner "servicemix"
  group "servicemix"
  mode "0777"
  action :create
  recursive true
end

servicemixfile = "/tmp/" + node["servicemix"]["file_name"] + "." + node["servicemix"]["file_type"]

remote_file servicemixfile do
  source node["servicemix"]["download_link"]
  mode "0755"
  not_if { ::File.exists?(servicemixfile) }
end

execute "extractgzip-apache-servicemix" do
  cwd '/opt/cloudengine/'
  command "unzip " + servicemixfile
  not_if { ::File.exists?("/opt/cloudengine/servicemix") }
end

execute "rename-servicemix-directory" do
  cwd '/opt/cloudengine/'
  command "mv " + node["servicemix"]["file_name"] + " servicemix"
  not_if { ::File.exists?("/opt/cloudengine/servicemix") }
end

#Change file ownership for the servicemix folder to servicemix
execute "servicemix-changefolderpermissions" do
  cwd "/opt/cloudengine/"
  command "chown -R servicemix:servicemix /opt/cloudengine/servicemix"
end

template 'servicemix-users' do
  path "/opt/cloudengine/servicemix/etc/users.properties"
  source "users.properties.erb"
  mode 0770
  owner 'servicemix'
  group 'servicemix'
  variables({
    :user_name => node["servicemix"]["user_name"],
    :user_password => node["servicemix"]["user_password"]
  })
  action :create
end

execute "servicemix-startserver" do
  cwd "/opt/cloudengine/servicemix/bin/"
  user 'servicemix'
  command "./servicemix server & >> /dev/null"
  not_if { ::File.exists?("/opt/cloudengine/servicemix/etc/servicemix-wrapper.conf") }
end

ruby_block "sleep-afterserverstart" do
  block do
    sleep(80)
  end
  not_if { ::File.exists?("/opt/cloudengine/servicemix/etc/servicemix-wrapper.conf") }
end

execute "servicemix-installwrapper" do
  cwd "/opt/cloudengine/servicemix/bin/"
  user 'servicemix'
  command "./client -h localhost -u " + node["servicemix"]["user_name"] + " -p " + node["servicemix"]["user_password"] + " -v \"features:install wrapper\""
  not_if { ::File.exists?("/opt/cloudengine/servicemix/etc/servicemix-wrapper.conf") }
  ignore_failure true
end

execute "servicemix-installwrapper" do
  cwd "/opt/cloudengine/servicemix/bin/"
  user 'servicemix'
  command "./client -h localhost -u " + node["servicemix"]["user_name"] + " -p " + node["servicemix"]["user_password"] + " -v \"features:install camel-jetty\""
  not_if { ::File.exists?("/opt/cloudengine/servicemix/etc/servicemix-wrapper.conf") }
  ignore_failure true
end

execute "servicemix-createservice" do
  cwd "/opt/cloudengine/servicemix/bin/"
  user 'servicemix'
  command "./client -h localhost -u " + node["servicemix"]["user_name"] + " -p " + node["servicemix"]["user_password"] + " -v \"wrapper:install -n servicemix -d servicemix -D 'Cloud Engine servicemix Service'\""
  not_if { ::File.exists?("/opt/cloudengine/servicemix/etc/servicemix-wrapper.conf") }
  ignore_failure true
end

ruby_block "sleep-afterservicecreate" do
  block do
    sleep(30)
  end
end

execute "servicemix-stopserver" do
  cwd "/opt/cloudengine/servicemix/bin/"
  user 'servicemix'
  command "./stop"
  ignore_failure true
end

execute "servicemix-insertnewline58" do
  cwd "/opt/cloudengine/servicemix/bin/"
  user 'servicemix'
  command "sed -i '58i\ RUN_AS_USER=servicemix' /opt/cloudengine/servicemix/bin/servicemix-service >> /dev/null"
  ignore_failure true
  not_if { ::File.exists?("/etc/init.d/servicemix-service") }
end

execute "servicemix-createaLink" do
  cwd "/etc/init.d/"
  user 'root'
  command "ln -s /opt/cloudengine/servicemix/bin/servicemix-service /etc/init.d/"
  not_if { ::File.exists?("/etc/init.d/servicemix-service") }
end

execute "servicemix-turnonservice" do
  cwd "/etc/init.d/"
  user 'root'
  command "chkconfig servicemix-service --add;chkconfig servicemix-service on"
end

template 'servicemix-moreusers' do
  path "/opt/cloudengine/servicemix/etc/users.properties"
  source "users.properties.erb2"
  mode 0770
  owner 'servicemix'
  group 'servicemix'
  variables({
    :user_password => node["servicemix"]["user_password"]
  })
  action :create
end

template 'servicemix-syspropsfix' do
  path "/opt/cloudengine/servicemix/etc/system.properties"
  source "system.properties.erb"
  mode 0770
  owner 'servicemix'
  group 'servicemix'
  action :create
end

template 'servicemix-karafjaasfix' do
  path "/opt/cloudengine/servicemix/etc/org.apache.karaf.jaas.cfg"
  source "org.apache.karaf.jaas.cfg.erb"
  mode 0770
  owner 'servicemix'
  group 'servicemix'
  action :create
end

template 'servicemix-orgops4jpaxloggingcfg' do
  path "/opt/cloudengine/servicemix/etc/org.ops4j.pax.logging.cfg"
  source "org.ops4j.pax.logging.cfg.erb"
  mode 0770
  owner 'servicemix'
  group 'servicemix'
  action :create
end

template 'servicemix-com-bah-cloudengine' do
  path "/opt/cloudengine/servicemix/etc/com.bah.cloudengine.cfg"
  source "com.bah.cloudengine.cfg.erb"
  mode 0770
  owner 'servicemix'
  group 'servicemix'
  variables({
    :user_name => node["servicemix"]["user_name"],
    :user_password => node["servicemix"]["user_password"]
  })
  action :create
end

remote_file 'servicemix-getroutes' do
  path "/opt/cloudengine/servicemix/deploy/" + node["servicemix"]["code_file_name"]
  source node["servicemix"]["code_url"]
  mode "0644"
end

execute "servicemix-changefolderpermissions" do
  cwd "/opt/cloudengine/"
  command "chown -R servicemix:servicemix /opt/cloudengine/servicemix"
end

service "servicemix-service" do
  action :restart
end

# Setup IPTABLES to allow servicemix to work
iptables_rule "ssh"
iptables_rule "tcp8181"
iptables_rule "tcp8182"
iptables_rule "tcp8183"
iptables_rule "tcp61616"
iptables_rule "tcp57904"
