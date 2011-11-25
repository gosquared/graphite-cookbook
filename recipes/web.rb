python_pip "Django" do
  version "1.3.1"
end

python_pip "python-memcached" do
  version "1.47"
end

python_pip "graphite_web" do
  version node.graphite.version
  directory "#{node.graphite.home}/webapp"
end

