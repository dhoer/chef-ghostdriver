def ghostdriver_exec
  ghostdriver =
    platform_family?('windows') ? node['ghostdriver']['windows']['exec'] : node['ghostdriver']['linux']['exec']
  ghostdriver_validate_exec(%("#{ghostdriver}" -v))
  ghostdriver
end

def ghostdriver_validate_exec(cmd)
  exec = Mixlib::ShellOut.new(cmd)
  exec.run_command
  exec.error!
end

def ghostdriver_home
  platform_family?('windows') ? node['ghostdriver']['windows']['home'] : node['ghostdriver']['linux']['home']
end

def ghostdriver_windows_service(name, exec, args)
  log_file = "#{ghostdriver_home}/log/#{name}.log"
  nssm name do
    program exec
    args args.join(' ').gsub('"', '"""')
    params(
      AppDirectory: ghostdriver_home,
      AppStdout: log_file,
      AppStderr: log_file,
      AppRotateFiles: 1
    )
    action :install
  end
end

# http://sqa.stackexchange.com/a/6267
def ghostdriver_windows_foreground(name, exec, args, username)
  args << %(-log "#{ghostdriver_home}/log/#{name}.log")
  cmd = "#{ghostdriver_home}/bin/#{name}.cmd"

  file cmd do
    content %("#{exec}" #{args.join(' ')})
    action :create
    notifies :request, "windows_reboot[Reboot to start #{name}]"
  end

  windows_shortcut "C:\\Users\\#{username}\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu"\
      "\\Programs\\Startup\\#{name}.lnk" do
    target cmd
    cwd ghostdriver_home
    action :create
  end
end

def ghostdriver_windows_firewall(name, port)
  execute "Firewall rule #{name} for port #{port}" do
    command "netsh advfirewall firewall add rule name=\"#{name}\" protocol=TCP dir=in profile=any"\
      " localport=#{port} remoteip=any localip=any action=allow"
    action :run
    not_if "netsh advfirewall firewall show rule name=\"#{name}\" > nul"
  end
end

def ghostdriver_autologon(username, password, domain = nil)
  return unless platform?('windows')
  node.set['windows_autologin']['username'] = username
  node.set['windows_autologin']['password'] = password
  node.set['windows_autologin']['domain'] = domain

  recipe_eval do
    run_context.include_recipe 'windows_autologin::default'
  end
end

def ghostdriver_linux_service(name, exec, args, port, display)
  username = 'ghostdriver'

  user "ensure user #{username} exits for #{name}" do
    username username
  end

  template "/etc/init.d/#{name}" do
    source "#{node['platform_family']}_initd.erb"
    cookbook 'ghostdriver'
    mode '0755'
    variables(
      name: name,
      user: username,
      exec: exec,
      args: args.join(' ').gsub('"', '\"'),
      port: port,
      display: display
    )
    notifies :restart, "service[#{name}]"
  end

  service name do
    supports restart: true, reload: true, status: true
    action [:enable]
  end
end
