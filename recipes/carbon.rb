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

