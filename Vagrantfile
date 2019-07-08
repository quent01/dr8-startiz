# -*- mode: ruby -*-
# vi: set ft=ruby :

# require 'json'

load "./provision/ruby/functions.inc.rb"

Vagrant.configure("2") do |config|
    
    config.vm.box = "scotch/box-pro"
    # config.vm.box = "scotch/box-pro-nginx"

    config.vm.hostname = "scotchbox"
    config.vm.network "forwarded_port", guest: 80, host: 8080
    config.vm.network "private_network", ip: "192.168.33.10"

    if Vagrant::Util::Platform.windows?
        # Optional NFS. Make sure to remove other synced_folder line too
        config.vm.synced_folder ".", "/var/www", :nfs => { :mount_options => ["dmode=777","fmode=666"] }
    else
        config.vm.synced_folder ".", "/var/www", :mount_options => ["dmode=777", "fmode=666"]
    end

    # Performance optimisation
    config.vm.provider "virtualbox" do |vb|
        # Customize the amount of memory on the VM:
        vb.memory = "4096"
        vb.cpus = "2"

        # Enabling multiple cores in Vagrant/VirtualBox
        vb.customize ["modifyvm", :id, "--ioapic", "on"]

        # change the network card hardware for better performance
        vb.customize ["modifyvm", :id, "--nictype1", "virtio" ]
        vb.customize ["modifyvm", :id, "--nictype2", "virtio" ]

        # suggested fix for slow network performance
        # see https://github.com/mitchellh/vagrant/issues/1807
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end

    config.vm.provision "shell", path: "provision/shell/provision--root.sh", keep_color: true
    config.vm.provision "shell", path: "provision/shell/provision--vagrant.sh", privileged: false, keep_color: true
end