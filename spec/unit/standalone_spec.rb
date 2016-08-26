require 'spec_helper'

describe 'ghostdriver_test::standalone' do
  # context 'windows' do
  #   let(:chef_run) do
  #     ChefSpec::SoloRunner.new(
  #       platform: 'windows', version: '2008R2', step_into: ['ghostdriver']
  #     ).converge(described_recipe)
  #   end
  #
  #   let(:shellout) do
  #     double(run_command: nil, error!: nil, error?: false, stdout: '1',
  #            stderr: double(empty?: true), exitstatus: 0,
  #            :live_stream= => double)
  #   end
  #
  #   before do
  #     stub_command('netsh advfirewall firewall show rule name="ghostdriver_standalone" > nul')
  #     allow(Mixlib::ShellOut).to receive(:new).and_return(shellout)
  #     allow_any_instance_of(Mixlib::ShellOut).to receive(:new).and_return(shellout)
  #   end
  #
  #   include Chef::Mixin::PowershellOut
  #
  #   it 'installs ghostdriver standalone server' do
  #     expect(chef_run).to install_ghostdriver('ghostdriver_standalone').with(
  #       webdriver: '10.0.0.2:8910'
  #     )
  #   end
  #
  #   it 'creates home directory' do
  #     expect(chef_run).to create_directory('C:/ghostdriver/log').with(
  #       recursive: true
  #     )
  #   end
  #
  #   it 'installs service' do
  #     expect(chef_run).to install_nssm('ghostdriver_standalone').with(
  #       program: 'C:/ProgramData/chocolatey/bin/phantomjs.exe',
  #       args: '--webdriver=10.0.0.2:8910',
  #       params: {
  #         AppDirectory: 'C:/ghostdriver',
  #         AppStdout: 'C:/ghostdriver/log/ghostdriver_standalone.log',
  #         AppStderr: 'C:/ghostdriver/log/ghostdriver_standalone.log',
  #         AppRotateFiles: 1
  #       }
  #     )
  #   end
  #
  #   it 'creates firewall rule' do
  #     expect(chef_run).to run_execute('Firewall rule ghostdriver_standalone for port 8910')
  #   end
  #
  #   it 'reboots windows server' do
  #     expect(chef_run).to_not request_windows_reboot('Reboot to start ghostdriver_standalone')
  #   end
  # end

  context 'linux' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'centos', version: '7.0', step_into: ['ghostdriver']
      ).converge(described_recipe)
    end

    it 'installs selenium_ghostdriver_nogrid server' do
      expect(chef_run).to install_ghostdriver('ghostdriver_standalone')
    end

    it 'creates ghostdriver user' do
      expect(chef_run).to create_user('ensure user ghostdriver exits for ghostdriver_standalone').with(
        username: 'ghostdriver'
      )
    end

    it 'install service' do
      expect(chef_run).to create_template('/etc/init.d/ghostdriver_standalone').with(
        source: 'rhel_initd.erb',
        cookbook: 'ghostdriver',
        mode: '0755',
        variables: {
          name: 'ghostdriver_standalone',
          user: 'ghostdriver',
          exec: '/usr/local/bin/phantomjs',
          args: '--webdriver=10.0.0.2:8910',
          port: 8910,
          display: nil
        }
      )
    end

    it 'start selenium_ghostdriver_nogrid' do
      expect(chef_run).to_not start_service('ghostdriver_standalone')
    end
  end
end
