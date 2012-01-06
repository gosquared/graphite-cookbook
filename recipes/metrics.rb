user "metrics" do
  supports  :manage_home => true
  home      "/home/#{node.graphite.metrics.user}"
  shell     '/bin/bash'
end

template "/etc/default/metrics" do
  owner "root"
  group "root"
  mode 0644
  backup false
end

bootstrap_profile node.graphite.metrics.user do
  filename "metrics"
  params [
    "[ -f /etc/default/metrics ] && . /etc/default/metrics"
  ]
end

cookbook_file "/usr/local/bin/record_metric" do
  owner node.graphite.metrics.user
  group node.graphite.metrics.user
  mode 0755
end

def one_but_last(array)
  array[-2]
end

node.graphite.metrics.collectors.each do |collector|
  service "metric-#{collector[:name]}" do
    supports :start => true, :stop => true, :restart => true
    provider Chef::Provider::Service::Upstart
  end

  if collector[:depends]
    collector[:depends].each do |script|
      cookbook_file "/home/#{node.graphite.metrics.user}/#{script}" do
        cookbook (collector[:cookbook] || "graphite")
        source "metrics/#{script}"
        owner node.graphite.metrics.user
        group node.graphite.metrics.user
        mode 0644
        action collector[:action]
      end
    end
  end

  collector_file = collector[:file] || "#{collector[:name]}.sh"

  if collector[:action] == :delete
    service "metric-#{collector[:name]}" do
      action :stop
    end

    execute "Removing metric-#{collector[:name]} & dependencies" do
      command %{
        rm /etc/init/metric-#{collector[:name]}.conf
        rm /home/#{node.graphite.metrics.user}/#{collector_file}
        initctl reload-configuration
      }
    end
  else
    cookbook_file "/home/#{node.graphite.metrics.user}/#{collector_file}" do
      cookbook (collector[:cookbook] || "graphite")
      source "metrics/#{collector_file}"
      owner node.graphite.metrics.user
      group node.graphite.metrics.user
      mode 0755
      notifies :restart, resources(:service => "metric-#{collector[:name]}"), :delayed
    end

    template "/etc/init/metric-#{collector[:name]}.conf" do
      cookbook "graphite"
      source "metrics/metric.upstart.erb"
      variables(
        :name   => collector[:name],
        :script => collector_file
      )
      owner "root"
      group "root"
      mode "0644"
      backup false
      notifies :restart, resources(:service => "metric-#{collector[:name]}"), :delayed
    end
  end
end
