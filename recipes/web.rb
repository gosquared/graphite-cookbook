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

file "/opt/graphite/webapp/wsgi.py" do
  content %{import os
import sys

PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))

os.environ['DJANGO_SETTINGS_MODULE'] = 'graphite.settings'

from django.core.handlers.wsgi import WSGIHandler
application = WSGIHandler()
  }
  mode "0750"
end

execute "correct permissions for graphite web" do
  command "chown -fR graphite.uwsgi #{node.graphite.home}/webapp"
end

include_recipe "python::uwsgi"
