python_pip "uWSGI" do
  # virtualenv "graphite"
end

python_pip "Django" do
  version "1.3.1"
  # virtualenv "graphite"
end

python_pip "python-memcached" do
  version "1.47"
  # virtualenv "graphite"
end

python_pip "graphite-web" do
  version node.graphite.version
  # virtualenv "graphite"
end

