python_pip "statsite" do
  version "0.4.0"
end

service "statsite" do
  supports :status => true, :restart => true, :reload => true
  provider Chef::Provider::Service::Upstart
end

template "/etc/init/statsite.conf" do
  cookbook "graphite"
  source "statsite.upstart.erb"
  notifies :restart, resources(:service => "statsite"), :delayed
  backup false
end

template "#{node.graphite.home}/conf/statsite.conf" do
  cookbook "graphite"
  owner "graphite"
  group "graphite"
  mode "0644"
  notifies :restart, resources(:service => "statsite"), :delayed
  backup false
end
