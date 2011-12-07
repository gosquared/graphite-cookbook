user "metrics" do
  supports  :manage_home => true
  home      "/home/#{node.graphite.metrics.user}"
  shell     '/bin/bash'
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

node.graphite.metrics.files.each do |metric|
  metric_name = one_but_last(metric[:filename].split("."))

  service "metric-#{metric_name}" do
    supports :start => true, :stop => true, :restart => true
    provider Chef::Provider::Service::Upstart
  end

  cookbook_file "/home/#{node.graphite.metrics.user}/#{metric[:filename]}" do
    cookbook (metric[:cookbook] || "graphite")
    source "metrics/#{metric[:filename]}"
    owner node.graphite.metrics.user
    group node.graphite.metrics.user
    mode 0644
    notifies :restart, resources(:service => "metric-#{metric_name}"), :delayed
  end

  template "/etc/init/metric-#{metric_name}.conf" do
    cookbook "graphite"
    source "metrics/metric.upstart.erb"
    variables(
      :name    => metric_name,
      :command => metric[:command]
    )
    owner "root"
    group "root"
    mode "0644"
    backup false
    notifies :restart, resources(:service => "metric-#{metric_name}"), :delayed
  end
end
