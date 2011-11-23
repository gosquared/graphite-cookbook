package "bzr"

execute "bzr txamqp" do
  command "bzr branch lp:txamqp"
  creates "#{node.graphite.src}/txamqp"
  cwd node.graphite.src
end

execute "install txamqp" do
  command "python setup.py install"
  creates "/usr/local/lib/python2.6/dist-packages/txAMQP-0.5-py2.6.egg/"
  cwd "#{node.graphite.src}/txamqp"
end
