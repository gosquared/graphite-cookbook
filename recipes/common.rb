include_recipe "python"

user "graphite" do
  # supports  :manage_home => true
  # home      "/opt/graphite"
  system true
  shell '/bin/sh'
end

# python_virtualenv "/opt/graphite" do
#   owner "graphite"
#   group "graphite"
# end

python_pip "yolk" do
  # virtualenv "graphite"
end
