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

python_pip "django-tagging" do
  version "0.3.1"
end

python_pip "simplejson" do
  version "2.2.1"
end

package "python-cairo"

# Defining it through uwsgi recipe, this feels much more elegant:
# http://www.jeremybowers.com/blog/post/5/django-nginx-and-uwsgi-production-serving-millions-page-views/
#
# file "/opt/graphite/webapp/wsgi.py" do
#   content %{import os
# import sys

# PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))

# os.environ['DJANGO_SETTINGS_MODULE'] = 'graphite.settings'

# from django.core.handlers.wsgi import WSGIHandler
# application = WSGIHandler()
#   }
#   mode "0750"
# end

# execute "correct permissions for graphite web" do
#   command "chown -fR graphite.uwsgi #{node.graphite.home}/webapp"
#   command "chmod -fR 755 #{node.graphite.home}/webapp"
#   command "chmod -fR 755 #{node.graphite.home}/storage/log/webapp"
# end

file "#{node.graphite.home}/webapp/favicon.ico" do
  owner "graphite"
  group "graphite"
end

include_recipe "python::uwsgi"

template "#{node.graphite.home}/conf/dashboard.conf" do
  cookbook "graphite"
  owner "graphite"
  group "graphite"
  mode "0644"
  notifies :restart, resources(:service => "uwsgi"), :delayed
  backup false
end

template "#{node.graphite.home}/webapp/graphite/local_settings.py" do
  cookbook "graphite"
  source "local_settings.py.erb"
  owner "graphite"
  group "graphite"
  mode "0644"
  notifies :restart, resources(:service => "uwsgi"), :delayed
  backup false
end

execute "syncdb" do
  command "yes no | python #{node.graphite.home}/webapp/graphite/manage.py syncdb"
  not_if "[ -f #{node.graphite.home}/storage/graphite.db ]"
end
