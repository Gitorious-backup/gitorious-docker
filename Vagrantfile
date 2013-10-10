# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "raring64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.network :forwarded_port, guest: 7080, host: 7080
  config.vm.network :forwarded_port, guest: 7022, host: 7022
  config.vm.network :forwarded_port, guest: 9418, host: 9418

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provision "shell", inline: "curl https://get.docker.io/gpg | apt-key add - && echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list && apt-get update -y && apt-get -y install linux-image-extra-`uname -r` lxc-docker"
end
