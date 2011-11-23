package "python-sqlite"
package "python-amqplib"
package "python-twisted"

remote_file "#{node.graphite.src}/#{node.graphite.carbon.dir}.tar.gz" do
  source node.graphite.carbon.uri
  checksum node.graphite.carbon.checksum
  action :create_if_missing
end

execute "untar carbon" do
  command "tar xzf #{node.graphite.carbon.dir}.tar.gz"
  creates "#{node.graphite.src}/#{node.graphite.carbon.dir}"
  cwd node.graphite.src
end

execute "install carbon" do
  command "python setup.py install"
  creates "#{node.graphite.home}/lib/#{node.graphite.carbon.dir}-py2.6.egg-info"
  cwd "#{node.graphite.src}/#{node.graphite.carbon.dir}"
end

service "carbon-cache" do
  supports :status => true, :restart => true, :reload => true
  provider Chef::Provider::Service::Upstart
end

template "#{node.graphite.home}/conf/carbon.conf" do
  notifies :restart, resources(:service => "carbon-cache")
end

template "#{node.graphite.home}/conf/storage-schemas.conf" do
  notifies :restart, resources(:service => "carbon-cache")
end

template "/etc/init/carbon-cache.conf" do
  source "carbon-cache.upstart.erb"
  mode "0644"
  notifies :restart, resources(:service => "carbon-cache")
end

execute "correct permissions for graphite folder" do
  command %{
    chown -fR graphite. #{node.graphite.home}
    chmod -fR 750 #{node.graphite.home}
  }
end

service "carbon-cache" do
  pattern "carbon-cache"
  action [:enable, :start]
end

