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

  config.vm.define "trusty", autostart: false do |trusty|
    trusty.vm.box = "ubuntu/trusty64"
  end

  config.vm.define "jessie", autostart: false do |jessie|
    jessie.vm.box = "debian/jessie64"
  end

  config.vm.define "wheezy", autostart: false do |wheezy|
    wheezy.vm.box = "debian/wheezy64"
  end

  config.vm.network :forwarded_port, guest: 6001, host: 6001, auto_correct: true  # SIP2
  config.vm.network :forwarded_port, guest: 80,   host: 8080, auto_correct: true  # OPAC
  config.vm.network :forwarded_port, guest: 8080, host: 8081, auto_correct: true  # INTRA
  config.vm.network "private_network", ip: "192.168.50.10"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  if ENV['SYNC_REPO']
    config.vm.synced_folder ENV['SYNC_REPO'], "/home/vagrant/kohaclone", type: "nfs"
  end

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "site.yml"
    ansible.host_key_checking = false
    ansible.extra_vars = { ansible_ssh_user: "vagrant", testing: true }
  end
  
  config.vm.post_up_message = "Welcome to KohaDevBox!\nSee https://github.com/digibib/kohadevbox for details"

end
