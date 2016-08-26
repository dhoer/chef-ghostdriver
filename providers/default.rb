use_inline_resources

def whyrun_supported?
  true
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
    run_context.include_recipe 'phantomjs::default'
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
