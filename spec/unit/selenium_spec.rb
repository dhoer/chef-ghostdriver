require 'spec_helper'

describe 'ghostdriver_test::phantomjs_selenium' do
  let(:shellout) { double(run_command: nil, error!: nil, stdout: ' ') }

  before { allow(Mixlib::ShellOut).to receive(:new).and_return(shellout) }

  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2008R2', step_into: ['ghostdriver']) do
        stub_command("netsh advfirewall firewall show rule name=\"ghostdriver\" > nul")
      end.converge(described_recipe)
    end

    it 'installs ghostdriver selenium server' do
      expect(chef_run).to install_ghostdriver('ghostdriver')
    end

    it 'install ghostdriver service' do
      expect(chef_run).to install_nssm('ghostdriver').with(
        program: 'C:/ProgramData/chocolatey/bin/phantomjs.exe',
        args: '--webdriver=10.0.0.2:8910 --webdriver-selenium-grid-hub=http://10.0.0.2:4444',
        params: {
          AppDirectory: 'C:/ghostdriver',
          AppStdout: 'C:/ghostdriver/log/ghostdriver.log',
          AppStderr: 'C:/ghostdriver/log/ghostdriver.log',
          AppRotateFiles: 1
        }
      )
    end

    it 'creates firewall rule' do
      expect(chef_run).to run_execute('Firewall rule ghostdriver for port 8910')
    end

    it 'reboots windows server' do
      expect(chef_run).to_not request_windows_reboot('Reboot to start ghostdriver')
    end
  end

  context 'linux' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        file_cache_path: '/var/chef/cache', platform: 'centos', version: '7.0', step_into: ['ghostdriver']
      ).converge(described_recipe)
    end

    it 'installs selenium_ghostdriver server' do
      expect(chef_run).to install_ghostdriver('ghostdriver')
    end

    it 'creates selenium user' do
      expect(chef_run).to create_user('ensure user ghostdriver exits for ghostdriver').with(username: 'ghostdriver')
    end

    it 'install selenium_ghostdriver' do
      expect(chef_run).to create_template('/etc/init.d/ghostdriver').with(
        source: 'rhel_initd.erb',
        cookbook: 'ghostdriver',
        mode: '0755',
        variables: {
          name: 'ghostdriver',
          user: 'ghostdriver',
          exec: '/usr/local/bin/ghostdriver',
          args: '--webdriver=10.0.0.2:8910 --webdriver-selenium-grid-hub=http://10.0.0.2:4444',
          port: 8910,
          display: nil
        }
      )
    end

    it 'start selenium_ghostdriver' do
      expect(chef_run).to_not start_service('ghostdriver')
    end
  end
end
