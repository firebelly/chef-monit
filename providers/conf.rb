use_inline_resource


action :create do
  if new_resource.type == :file && !new_resource.path
    Chef::Log.fatal("Type: #{new_resource.type.to_s} requires a path attribute.")
  end
  if new_resource.type == :process && !new_resource.pid
    Chef::Log.fatal("Type: #{new_resource.type.to_s} requires a pid attribute.")
  end

  withs = case new_resource.type
          when :process
            "with pidfile #{new_resource.pid}"
          when :host
            "with address #{node['ipaddress']}"
          else
            "with path #{new_resource.path}"
          end


  template "/etc/monit/conf.d/#{new_resource.name}.conf" do
    owner "root"
    group "root"
    mode 0644
    source new_resource.template
    cookbook new_resource.cookbook
    variables(
      :depends => new_resource.depends,
      :group => new_resource.group,
      :name => new_resource.name,
      :rule => new_resource.rule,
      :start => new_resource.start,
      :start_as => new_resource.start_as,
      :stop => new_resource.stop,
      :stop_as => new_resource.stop_as,
      :type => new_resource.type,
      :mode => new_resource.mode,
      :withs => withs
    )
    notifies :restart, "service[monit]", new_resource.reload
  end
end

action :delete do
  template "/etc/monit/conf.d/#{new_resource.name}.conf" do
    action :delete
    source new_resource.template
    cookbook new_resource.cookbook
    notifies :restart, "service[monit]", new_resource.reload
  end
end
