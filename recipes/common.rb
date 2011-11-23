include_recipe "python"

package "python-dev"

directory node.graphite.src

user node.graphite.carbon.user do
  system true
  shell "/bin/sh"
end

