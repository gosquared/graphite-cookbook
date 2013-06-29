package "libsqlite3-dev"

directory node[:graphite][:carbon][:log_dir] do
  owner "graphite"
  group "graphite"
  mode 0755
  recursive true
  action :create
end

python_pip "pysqlite" do
  version "2.6.3"
end

python_pip "Twisted" do
  version "11.1.0"
end

python_pip "txAMQP" do
  version "0.5"
end

python_pip "carbon" do
  version node.graphite.version
  directory "#{node.graphite.home}/lib"
end

service "carbon-cache" do
  supports :status => true, :restart => true, :reload => true
  provider Chef::Provider::Service::Upstart
end

template "#{node.graphite.home}/conf/carbon.conf" do
  cookbook "graphite"
  notifies :restart, resources(:service => "carbon-cache"), :delayed
  backup false
end

template "#{node.graphite.home}/conf/storage-schemas.conf" do
  cookbook "graphite"
  notifies :restart, resources(:service => "carbon-cache"), :delayed
  backup false
end

template "/etc/init/carbon-cache.conf" do
  cookbook "graphite"
  source "carbon-cache.upstart.erb"
  mode "0644"
  notifies :restart, resources(:service => "carbon-cache"), :delayed
  backup false
end

service "carbon-cache" do
  pattern "carbon-cache"
  action [:enable, :start]
end

