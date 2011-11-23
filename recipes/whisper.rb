directory node.graphite.src

remote_file "#{node.graphite.src}/#{node.graphite.whisper.dir}.tar.gz" do
  source node.graphite.whisper.uri
  checksum node.graphite.whisper.checksum
  action :create_if_missing
end

execute "untar whisper" do
  command "tar xzf #{node.graphite.whisper.dir}.tar.gz"
  creates "#{node.graphite.src}/#{node.graphite.whisper.dir}"
  cwd node.graphite.src
end

execute "install whisper" do
  command "python setup.py install"
  creates "/usr/local/lib/python2.6/dist-packages/#{node.graphite.whisper.dir}.egg-info"
  cwd "#{node.graphite.src}/#{node.graphite.whisper.dir}"
end
