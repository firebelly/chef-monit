# Working init script, fix for: https://bugs.launchpad.net/ubuntu/+source/monit/+bug/993381
template "/etc/init.d/monit" do
  source 'init-monit-ubuntu12.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables :config_file => node[:monit][:config_file]
end
