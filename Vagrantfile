# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  # 
  config.vm.box = "ubuntu/precise64"

  config.vm.synced_folder './', '/vagrant', disabled: false, create: true

  config.vm.provider :virtualbox do |vb, override|
  
    vb.name = "gisgraphy-standalone"

    override.vm.provision :shell do |s|
      s.path = "provision/install.sh"
    end
    
    override.vm.network "forwarded_port", guest: 8080, host: 8080
    override.vm.network "forwarded_port", guest: 8081, host: 8081
    override.vm.network "forwarded_port", guest: 5432, host: 6000

  end
  
end

