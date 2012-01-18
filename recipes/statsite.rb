python_pip "statsite" do
  version "0.4.0"
end

service "statsite" do
  provider Chef::Provider::Service::Upstart
end

if node[:graphite][:statsite][:disable]
  bash "Removing statsite" do
    code %{
      stop statsite
      rm -f /etc/init/statsite.conf
      rm -f #{node[:graphite][:home]}/conf/statsite.conf
    }
    only_if "[ $(initctl list | grep -c statsite) > 0 ]"
  end
else
  template "/etc/init/statsite.conf" do
    cookbook "graphite"
    source "statsite.upstart.erb"
    notifies :restart, resources(:service => "statsite"), :delayed
    backup false
  end

  template "#{node[:graphite][:home]}/conf/statsite.conf" do
    cookbook "graphite"
    owner "graphite"
    group "graphite"
    mode "0644"
    notifies :restart, resources(:service => "statsite"), :delayed
    backup false
  end
end
