# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'fileutils' 

module OS
    # Try detecting Windows
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end
end

Vagrant.configure(2) do |config|

  # http://fgrehm.viewdocs.io/vagrant-cachier
  if Vagrant.has_plugin?("vagrant-cachier") and not OS.windows?
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

  # Default to host's ansible
  provisioner = :ansible
  local_ansible = false

  if ENV['LOCAL_ANSIBLE'] or OS.windows?
    local_ansible = true
  end

  config.vm.hostname = "kohadevbox"
  if OS.windows?
    config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  end

  config.vm.define "jessie", primary: true do |jessie|
    jessie.vm.box = "debian/jessie64"
  end

  config.vm.define "wheezy", autostart: false do |wheezy|
    wheezy.vm.box = "debian/wheezy64"
  end

  config.vm.define "trusty", autostart: false do |trusty|
    trusty.vm.box = "ubuntu/trusty64"
  end

  config.vm.define "xenial", autostart: false do |xenial|
    xenial.vm.box = "ubuntu/xenial64"
  end

  config.vm.network :forwarded_port, guest: 6001, host: 6001, auto_correct: true  # SIP2
  config.vm.network :forwarded_port, guest: 80,   host: 8080, auto_correct: true  # OPAC
  config.vm.network :forwarded_port, guest: 8080, host: 8081, auto_correct: true  # INTRA
  config.vm.network :forwarded_port, guest: 9200, host: 9200, auto_correct: true  # ES
  config.vm.network "private_network", ip: "192.168.50.10"

  config.vm.provider :virtualbox do |vb|
    if ENV['KOHA_ELASTICSEARCH']
      vb.customize ["modifyvm", :id, "--memory", "4096"]
    else
      vb.customize ["modifyvm", :id, "--memory", "2048"]
    end
  end

  if ENV['SYNC_REPO']
    if OS.windows?
      unless Vagrant.has_plugin?("vagrant-vbguest")
        raise 'The vagrant-vbguest plugin is not present, and is mandatory for SYNC_REPO on Windows! See README.md'
      end

      config.vm.synced_folder ENV['SYNC_REPO'], "/home/vagrant/kohaclone", type: "virtualbox"

    else
      # We should safely rely on NFS
      config.vm.synced_folder ENV['SYNC_REPO'], "/home/vagrant/kohaclone", type: "nfs"
    end
  end

  if ENV['PLUGIN_REPO']
    if OS.windows?
      unless Vagrant.has_plugin?("vagrant-vbguest")
        raise 'The vagrant-vbguest plugin is not present, and is mandatory for PLUGIN_REPO on Windows! See README.md'
      end

      config.vm.synced_folder ENV['PLUGIN_REPO'], "/home/vagrant/koha_plugin", type: "virtualbox"

    else
      # We should safely rely on NFS
      config.vm.synced_folder ENV['PLUGIN_REPO'], "/home/vagrant/koha_plugin", type: "nfs"
    end
  end

  if local_ansible
    provisioner = :ansible_local
    config.vm.provision :shell, path: "tools/install-ansible.sh"
  end

  config.vm.provision provisioner do |ansible|
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

    if ENV['CREATE_ADMIN_USER']
      ansible.extra_vars.merge!({ create_admin_user: true });
    end

    ansible.playbook = "site.yml"
    if local_ansible
      ## Special variables needed for :ansible_local go here
      # We install our own ansible, which is newer
      ansible.install  = false
    end
  end

  config.vm.post_up_message = "Welcome to KohaDevBox!\nSee https://github.com/digibib/kohadevbox for details"

end
