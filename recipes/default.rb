package "monit" do
  action :install
end

case node['platform_family']
when "debian"
  ruby_block 'update /etc/default/monit' do
    block do
      require 'chef/util/file_edit'
      monit_default = Chef::Util::FileEdit.new("/etc/default/monit")
      monit_default.search_file_replace_line(/^startup=0/, "startup=1")
      monit_default.write_file
    end
    action :create
    ignore_failure true
  end
when 'rhel'
  template '/etc/init.d/monit' do
    source 'initd.erb'
    mode '0744'
    variables :config_file => '/etc/monit/monitrc'
    notifies :restart, "service[monit]", :delayed
  end

  file '/etc/monit.conf' do
    action :delete
  end
  directory '/etc/monit.d' do
    action :delete
    recursive true
  end
end

directory "/etc/monit" do
  owner 'root'
  group 'root'
  mode '0775'
end

template "/etc/monit/monitrc" do
  owner "root"
  group "root"
  mode '0700'
  source 'monitrc.erb'
  notifies :restart, "service[monit]", :delayed
end

service "monit" do
  action [:enable, :start]
  enabled true
  supports [:start, :restart, :stop, :status]
end

directory "/etc/monit/conf.d/" do
  owner  'root'
  group 'root'
  mode 0755
  action :create
  recursive true
end

node['monit']['include'].each do |recipe|
  include_recipe "monit::#{recipe}"
end
