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
  converge_by("Install ghostdriver Service: #{new_resource.name}") do
    case node['platform']
    when 'windows'
      if new_resource.username && new_resource.password
        ghostdriver_windows_foreground(new_resource.name, ghostdriver_exec, ghostdriver_args, new_resource.username)
        ghostdriver_autologon(new_resource.username, new_resource.password, new_resource.domain)
      else
        ghostdriver_windows_service(new_resource.name, ghostdriver_exec, ghostdriver_args)
      end

      ghostdriver_windows_firewall(new_resource.name, ghostdriver_port(new_resource.webdriver))

      windows_reboot "Reboot to start #{new_resource.name}" do
        reason "Reboot to start #{new_resource.name}"
        timeout node['windows']['reboot_timeout']
        action :nothing
      end
    when 'mac_os_x'
      log('Mac OS X is not supported!') { level :warn }
    else
      ghostdriver_linux_service(
        new_resource.name, ghostdriver_exec, ghostdriver_args, ghostdriver_port(new_resource.webdriver), nil)
    end
  end
end
