use_inline_resources

def whyrun_supported?
  true
end

def ghostdriver_exec
  ghostdriver = new_resource.exec
  ghostdriver_validate_exec("#{ghostdriver} -v")
  ghostdriver
end

def ghostdriver_validate_exec(cmd)
  exec = Mixlib::ShellOut.new(cmd)
  exec.run_command
  exec.error!
end

def ghostdriver_windows_service(name, exec, args)
  log_file = "#{node['ghostdriver']['windows']['home']}/log/#{name}.log"
  nssm name do
    program exec
    args args.join(' ').gsub('"', '"""')
    params(
      AppDirectory: node['ghostdriver']['windows']['home'],
      AppStdout: log_file,
      AppStderr: log_file,
      AppRotateFiles: 1
    )
    action :install
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

# returns webdriver port '1234' for 'localhost:1234' or '1234'
def ghostdriver_port(webdriver)
  webdriver.match(/.*[:](.*)/).captures[0].to_i
rescue
  webdriver.to_i
end

def ghostdriver_args
  args = []
  args << "--webdriver=#{new_resource.webdriver}"
  unless new_resource.webdriverSeleniumGridHub.nil?
    args << "--webdriver-selenium-grid-hub=#{new_resource.webdriverSeleniumGridHub}"
  end
  args
end

action :install do
  return Chef::Log.warn('Mac OS X is not supported!') if platform?('mac_os_x')
  recipe_eval do
    run_context.include_recipe 'phantomjs2::default'
  end

  case node['platform']
  when 'windows'
    directory "#{node['ghostdriver']['windows']['home']}/log" do
      recursive true
      action :create
    end

    ghostdriver_windows_service(new_resource.name, ghostdriver_exec, ghostdriver_args)
    ghostdriver_windows_firewall(new_resource.name, ghostdriver_port(new_resource.webdriver))

    windows_reboot "Reboot to start #{new_resource.name}" do
      reason "Reboot to start #{new_resource.name}"
      timeout node['windows']['reboot_timeout']
      action :nothing
    end
  else
    ghostdriver_linux_service(
      new_resource.name, ghostdriver_exec, ghostdriver_args, ghostdriver_port(new_resource.webdriver), nil
    )
  end
end
