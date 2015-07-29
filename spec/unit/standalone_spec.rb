require 'spec_helper'

describe 'ghostdriver_test::phantomjs_standalone' do
  let(:shellout) { double(run_command: nil, error!: nil, stdout: ' ') }

  before { allow(Mixlib::ShellOut).to receive(:new).and_return(shellout) }

  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2008R2', step_into: ['ghostdriver']) do
        allow_any_instance_of(Chef::Recipe).to receive(:ghostdriver_home).and_return('C:/ghostdriver')
        stub_command("netsh advfirewall firewall show rule name=\"ghostdriver_standalone\" > nul")
      end.converge(described_recipe)
    end

    it 'installs ghostdriver standalone server' do
      expect(chef_run).to install_ghostdriver('ghostdriver_standalone').with(
        username: 'vagrant',
        password: 'vagrant',
        webdriver: 'localhost:8911'
      )
    end

    it 'creates shortcut to selenium cmd file' do
      expect(chef_run).to create_windows_shortcut(
        'C:\Users\vagrant\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\ghostdriver_standalone.lnk'
      )
    end

    it 'creates selenium foreground command' do
      expect(chef_run).to create_file('C:/ghostdriver/bin/ghostdriver_standalone.cmd').with(
        content: '"C:/ProgramData/chocolatey/bin/phantomjs.exe" --webdriver=localhost:8911 -log '\
          '"C:/ghostdriver/log/ghostdriver_standalone.log"'
      )
    end

    it 'creates firewall rule' do
      expect(chef_run).to run_execute('Firewall rule ghostdriver_standalone for port 8911')
    end

    it 'reboots windows server' do
      expect(chef_run).to_not request_windows_reboot('Reboot to start ghostdriver_standalone')
    end
  end

  context 'linux' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0', step_into: ['ghostdriver']) do
        allow_any_instance_of(Chef::Recipe).to receive(:ghostdriver_home).and_return('/var/local/ghostdriver')
      end.converge(described_recipe)
    end

    it 'installs selenium_ghostdriver_nogrid server' do
      expect(chef_run).to install_ghostdriver('ghostdriver_standalone')
    end

    it 'creates ghostdriver user' do
      expect(chef_run).to create_user('ensure user ghostdriver exits for ghostdriver_standalone').with(
        username: 'ghostdriver')
    end

    it 'install ghostdriver_standalone' do
      expect(chef_run).to create_template('/etc/init.d/ghostdriver_standalone').with(
        source: 'rhel_initd.erb',
        cookbook: 'ghostdriver',
        mode: '0755',
        variables: {
          name: 'ghostdriver_standalone',
          user: 'ghostdriver',
          exec: '/usr/local/bin/ghostdriver',
          args: '--webdriver=localhost:8911',
          port: 8911,
          display: nil
        }
      )
    end

    it 'start selenium_ghostdriver_nogrid' do
      expect(chef_run).to_not start_service('ghostdriver_standalone')
    end
  end
end
