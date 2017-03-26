# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# get details of boxes to build
boxes = YAML.load_file('./boxes.yaml')

# API version
VAGRANTFILE_API_VERSION = 2

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  boxes.each do |boxes|
    config.vm.define boxes['name'] do |srv|
      # OS and hostname
      srv.vm.box = boxes['box']
      if boxes['box_version']
        srv.vm.box_version = boxes['box_version']
      end
      srv.vm.hostname = boxes['name']

      # Networking.  By default a NAT interface is added.
      # Add an internal network like this:
      #   srv.vm.network 'private_network', type: 'dhcp', virtualbox__intnet: true
      # Add a bridged network
      if boxes['public_network']
        if boxes['public_network']['ip']
          srv.vm.network 'public_network', bridge: boxes['public_network']['bridge'], ip: boxes['public_network']['ip']
        else
          srv.vm.network 'public_network', bridge: boxes['public_network']['bridge']
        end
      end

      if boxes['ssh_port']
        srv.vm.network :forwarded_port, guest: 22, host: boxes['ssh_port'], id: 'ssh'
      end

      # Shared folders
      srv.vm.synced_folder '.', '/vagrant', disabled: true

      srv.vm.provider 'virtualbox' do |vb|
        vb.customize ['modifyvm', :id, '--cpus', boxes['cpus']]
        vb.customize ['modifyvm', :id, '--cpuexecutioncap', boxes['cpu_execution_cap']]
        vb.customize ['modifyvm', :id, '--memory', boxes['ram']]
        vb.customize ['modifyvm', :id, '--name', boxes['name']]
        vb.customize ['modifyvm', :id, '--description', boxes['description']]
        vb.customize ['modifyvm', :id, '--groups', '/vagrant']
      end

      # Copy cloud-init files to tmp and provision
      if boxes['provision']
        srv.vm.provision :file, :source => boxes['provision']['meta-data'], :destination => '/tmp/vagrant/cloud-init/nocloud-net/meta-data'
        srv.vm.provision :file, :source => boxes['provision']['user-data'], :destination => '/tmp/vagrant/cloud-init/nocloud-net/user-data'
        srv.vm.provision :shell, :path => boxes['provision']['script']
      end
    end
  end
end
