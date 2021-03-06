require 'spec_helper'

describe 'ghostdriver_test::selenium' do
  let(:shellout) do
    double(run_command: nil, error!: nil, error?: false, stdout: '1',
           stderr: double(empty?: true), exitstatus: 0,
           :live_stream= => nil)
  end

  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2008R2', step_into: ['ghostdriver']) do
        ENV['ProgramData'] = 'C:/ProgramData'
        ENV['SYSTEMDRIVE'] = 'C:'
        allow(Mixlib::ShellOut).to receive(:new).with(
          'C:/ProgramData/phantomjs/phantomjs/phantomjs.exe -v'
        ).and_return(shellout)
        stub_command('netsh advfirewall firewall show rule name="ghostdriver_selenium_node" > nul')
      end.converge(described_recipe)
    end

    it 'installs ghostdriver selenium server' do
      expect(chef_run).to install_ghostdriver('ghostdriver_selenium_node')
    end

    it 'creates home directory' do
      expect(chef_run).to create_directory('C:/ghostdriver/log').with(
        recursive: true
      )
    end

    it 'install service' do
      expect(chef_run).to install_nssm('ghostdriver_selenium_node').with(
        program: 'C:/ProgramData/phantomjs/phantomjs/phantomjs.exe',
        args: '--webdriver=10.0.0.2:8911 --webdriver-selenium-grid-hub=http://10.0.0.2:4444',
        params: {
          AppDirectory: 'C:/ghostdriver',
          AppStdout: 'C:/ghostdriver/log/ghostdriver_selenium_node.log',
          AppStderr: 'C:/ghostdriver/log/ghostdriver_selenium_node.log',
          AppRotateFiles: 1
        }
      )
    end

    it 'creates firewall rule' do
      expect(chef_run).to run_execute('Firewall rule ghostdriver_selenium_node for port 8911')
    end

    it 'reboots windows server' do
      expect(chef_run).to_not request_windows_reboot('Reboot to start ghostdriver_selenium_node')
    end
  end

  context 'linux' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0', step_into: ['ghostdriver']) do
        allow(Mixlib::ShellOut).to receive(:new).with('/usr/local/bin/phantomjs -v').and_return(shellout)
        allow_any_instance_of(Chef::Provider).to receive(:systype).and_return('systemv')
      end.converge(described_recipe)
    end

    it 'installs selenium_hub server' do
      expect(chef_run).to install_selenium_hub('selenium_hub')
    end

    it 'installs selenium_ghostdriver server' do
      expect(chef_run).to install_ghostdriver('ghostdriver_selenium_node')
    end

    it 'creates selenium user' do
      expect(chef_run).to create_user('ensure user ghostdriver exits for ghostdriver_selenium_node').with(
        username: 'ghostdriver'
      )
    end

    it 'install service' do
      expect(chef_run).to create_template('/etc/init.d/ghostdriver_selenium_node').with(
        source: 'systemv.erb',
        cookbook: 'ghostdriver',
        mode: '0755',
        variables: {
          name: 'ghostdriver_selenium_node',
          user: 'ghostdriver',
          exec: '/usr/local/bin/phantomjs',
          args: '--webdriver=10.0.0.2:8911 --webdriver-selenium-grid-hub=http://10.0.0.2:4444',
          port: 8911,
          display: nil
        }
      )
    end

    it 'start selenium_ghostdriver' do
      expect(chef_run).to_not start_service('ghostdriver_selenium_node')
    end
  end
end
