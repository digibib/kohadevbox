# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'fileutils' 

Vagrant.configure(2) do |config|

  # http://fgrehm.viewdocs.io/vagrant-cachier
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  else
    puts "Run 'vagrant plugin install vagrant-cachier' to speed up provisioning."
  end

  config.vm.hostname = "kohadevbox"
  config.vm.box = "chef/debian-7.6"

  config.vm.network :forwarded_port, guest: 6001, host: 6001, auto_correct: true  # SIP2
  config.vm.network :forwarded_port, guest: 80,   host: 8080, auto_correct: true  # OPAC
  config.vm.network :forwarded_port, guest: 8080, host: 8081, auto_correct: true  # INTRA
  config.vm.network :forwarded_port, guest: 5000, host: 5000, auto_correct: true  # Plack OPAC
  config.vm.network :forwarded_port, guest: 5001, host: 5001, auto_correct: true  # Plack INTRA

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "768"]
  end

  if ENV['SYNC_REPO']
    config.vm.synced_folder ENV['SYNC_REPO'], "/home/vagrant/kohaclone"
  end

  config.vm.provision "shell", path: "setup-koha.sh", privileged: false
  config.vm.provision "shell", path: "run_always.sh", privileged: false, run: "always"
  
  config.vm.post_up_message = "Welcome to KohaDevBox!\nSee https://github.com/digibib/kohadevbox for details"

end
