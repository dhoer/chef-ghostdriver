require 'spec_helper'

describe 'ghostdriver::default' do
  let(:shellout) { double(run_command: nil, error!: nil, stdout: ' ') }

  # before { allow(Mixlib::ShellOut).to receive(:new).and_return(shellout) }

  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2008R2', step_into: ['ghostdriver']) do
        allow_any_instance_of(Chef::Recipe).to receive(:ghostdriver_home).and_return('C:/ghostdriver')
      end.converge(described_recipe)
    end

    it 'creates home directory' do
      expect(chef_run).to create_directory('C:/ghostdriver/log').with(
        recursive: true
      )
    end
  end

  context 'linux' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0', step_into: ['ghostdriver']) do
        allow_any_instance_of(Chef::Recipe).to receive(:ghostdriver_home).and_return('/var/local/ghostdriver')
      end.converge(described_recipe)
    end

    it 'creates home directory' do
      expect(chef_run).to create_directory('/var/local/ghostdriver/log').with(
        recursive: true
      )
    end
  end
end
