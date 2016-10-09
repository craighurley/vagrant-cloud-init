# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# get details of boxes to build
boxes = YAML.load_file('./boxes.yaml')

# API version
VAGRANTFILE_API_VERSION = 2

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  boxes.each do |box|
    config.vm.define box['name'] do |box_config|
      # OS and hostname
      box_config.vm.box = box['box']
      if box['box_version']
        box_config.vm.box_version = box['box_version']
      end
      box_config.vm.hostname = box['name']

      # Networking.  By default a NAT interface is added.
      # Add an internal network like this:
      #   box_config.vm.network 'private_network', type: 'dhcp', virtualbox__intnet: true
      # Add a bridged network
      if box['public_network']
        if box['public_network']['ip']
          box_config.vm.network 'public_network', bridge: box['public_network']['bridge'], ip: box['public_network']['ip']
        else
          box_config.vm.network 'public_network', bridge: box['public_network']['bridge']
        end
      end

      # Shared folders
      box_config.vm.synced_folder '.', '/vagrant', disabled: true

      box_config.vm.provider 'virtualbox' do |vb|
        vb.customize ['modifyvm', :id, '--cpus', box['cpus']]
        vb.customize ['modifyvm', :id, '--cpuexecutioncap', box['cpu_execution_cap']]
        vb.customize ['modifyvm', :id, '--memory', box['ram']]
        vb.customize ['modifyvm', :id, '--name', box['name']]
        vb.customize ['modifyvm', :id, '--description', box['description']]
        vb.customize ['modifyvm', :id, '--groups', '/vagrant']
      end

      # Copy cloud-init files to tmp and provision
      config.vm.provision :file, :source => './cloud-init/nocloud-net/meta-data.yaml', :destination => '/tmp/vagrant/cloud-init/nocloud-net/meta-data'
      config.vm.provision :file, :source => './cloud-init/nocloud-net/user-data.yaml', :destination => '/tmp/vagrant/cloud-init/nocloud-net/user-data'
      config.vm.provision :shell, :path => './scripts/provision.sh'
    end
  end
end
