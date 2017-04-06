# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "oradb" , primary: true do |oradb|

    oradb.vm.box = "centos-6.6-x86_64"
    oradb.vm.box_url = "https://dl.dropboxusercontent.com/s/ijt3ppej789liyp/centos-6.6-x86_64.box"

    oradb.vm.provider :vmware_fusion do |v, override|
      override.vm.box = "centos-6.6-x86_64-vmware"
      override.vm.box_url = "https://dl.dropboxusercontent.com/s/7ytmqgghoo1ymlp/centos-6.6-x86_64-vmware.box"
    end

    oradb.vm.hostname = "oradb.example.com"
    oradb.vm.network :private_network, ip: "10.10.10.5"


    oradb.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
    #oradb.vm.synced_folder "/Users/edwin/software", "/software"

    oradb.vm.provider :vmware_fusion do |vb|
      vb.vmx["numvcpus"] = "1"
      vb.vmx["memsize"] = "2000"
    end

    oradb.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm"     , :id, "--memory", "2000"]
      #vb.customize ["modifyvm"     , :id, "--name"  , "oradb"]
      #vb.name = "oradb"
    end


    oradb.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml"

    oradb.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "oradb.pp"
      puppet.options           = "--verbose --hiera_config /vagrant/puppet/hiera.yaml"

      puppet.facter = {
        "environment" => "development",
        "vm_type"     => "vagrant",
      }

    end

  end


end