# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.4"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64-phusion "

  config.vm.network :forwarded_port, guest: 7080, host: 7080
  config.vm.network :forwarded_port, guest: 7022, host: 7022
  config.vm.network :forwarded_port, guest: 9418, host: 9418

  config.vm.provider :virtualbox do |v, override|
    override.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vbox.box"
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provider :vmware_fusion do |v, override|
    override.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vmwarefusion.box"
  end

  config.vm.provision "docker"
  config.vm.provision "shell", inline: "su vagrant -c 'if [ ! -f /home/vagrant/.ssh/id_rsa.pub ]; then ssh-keygen -t rsa -f /home/vagrant/.ssh/id_rsa; fi'"
end
