include_recipe "graphite::common"
include_recipe "graphite::whisper"
include_recipe "graphite::carbon"
include_recipe "graphite::web"

execute "correct permissions for graphite folder" do
  command %{
    chown -fR graphite. #{node.graphite.home}
    cd #{node.graphite.home} && chmod -fR 777 *
  }
end
