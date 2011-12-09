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
  match "export HOSTNAME"
  string "export HOSTNAME='#{node.graphite.metrics.hostname || node.hostname}'"
end

bootstrap_profile node.graphite.metrics.user do
  match "export METRICS_IP"
  string "export METRICS_IP='#{node.graphite.metrics.ip}'"
end

bootstrap_profile node.graphite.metrics.user do
  match "export METRICS_PORT"
  string "export METRICS_PORT='#{node.graphite.metrics.port}'"
end

def one_but_last(array)
  array[-2]
end

node.graphite.metrics.collectors.each do |collector|
  service "metric-#{collector[:name]}" do
    supports :start => true, :stop => true, :restart => true
    provider Chef::Provider::Service::Upstart
  end

  collector_file = collector[:file] || "#{collector[:name]}.sh"
  cookbook_file "/home/#{node.graphite.metrics.user}/#{collector_file}" do
    cookbook (collector[:cookbook] || "graphite")
    source "metrics/#{collector_file}"
    owner node.graphite.metrics.user
    group node.graphite.metrics.user
    mode 0755
  end

  if collector[:depends]
    collector[:depends].each do |script|
      cookbook_file "/home/#{node.graphite.metrics.user}/#{script}" do
        cookbook (collector[:cookbook] || "graphite")
        source "metrics/#{script}"
        owner node.graphite.metrics.user
        group node.graphite.metrics.user
        mode 0644
      end
    end
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
