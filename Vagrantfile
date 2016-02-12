# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'fileutils' 

Vagrant.configure(2) do |config|

  # http://fgrehm.viewdocs.io/vagrant-cachier
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
    config.cache.synced_folder_opts = {
      type: :nfs,
      # The nolock option can be useful for an NFSv3 client that wants to avoid the
      # NLM sideband protocol. Without this option, apt-get might hang if it tries
      # to lock files needed for /var/cache/* operations. All of this can be avoided
      # by using NFSv4 everywhere. Please note that the tcp option is not the default.
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
  else
    puts "Run 'vagrant plugin install vagrant-cachier' to speed up provisioning."
  end

  config.vm.hostname = "kohadevbox"

  config.vm.define "jessie", primary: true do |jessie|
    jessie.vm.box = "debian/jessie64"
  end

  config.vm.define "wheezy", autostart: false do |wheezy|
    wheezy.vm.box = "debian/wheezy64"
  end

  config.vm.define "trusty", autostart: false do |trusty|
    trusty.vm.box = "ubuntu/trusty64"
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
    ansible.extra_vars = { ansible_ssh_user: "vagrant", testing: true }

    if ENV['SKIP_WEBINSTALLER']
      ansible.extra_vars.merge!({ skip_webinstaller: true })
    end

    if ENV['SYNC_REPO']
      ansible.extra_vars.merge!({ sync_repo: true });
    end

    if ENV['KOHA_ELASTICSEARCH']
      ansible.extra_vars.merge!({ elasticsearch: true });
    end

    ansible.playbook = "site.yml"
    ansible.host_key_checking = false
  end
  
  config.vm.post_up_message = "Welcome to KohaDevBox!\nSee https://github.com/digibib/kohadevbox for details"

end
