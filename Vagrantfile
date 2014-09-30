# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'fileutils' 

Vagrant.configure(2) do |config|

  config.vm.hostname = "kohadevbox"
  config.vm.box = "chef/debian-7.6"

  config.vm.network :forwarded_port, guest: 6001, host: 6001  # SIP2
  config.vm.network :forwarded_port, guest: 80,   host: 8080  # OPAC
  config.vm.network :forwarded_port, guest: 8080, host: 8081  # INTRA

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "768"]
  end

  config.vm.provision "shell", path: "setup-koha.sh", privileged: false

end
