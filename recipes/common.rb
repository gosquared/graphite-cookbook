include_recipe "python"

user "graphite" do
  system true
  shell '/bin/sh'
end

python_pip "yolk"
