template '/etc/pam.d/monit' do
  source 'pam.erb'
  owner 'root'
  group 'root'
end
