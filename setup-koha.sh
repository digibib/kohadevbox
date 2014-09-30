#!/bin/bash

# Get the configuration variables
source "/vagrant/config.cfg"

# Add some more sources to apt
echo "deb http://ftp.indexdata.dk/debian wheezy main" | sudo tee /etc/apt/sources.list.d/zebra.list
wget --quiet -O- "http://ftp.indexdata.dk/debian/indexdata.asc" | sudo apt-key add -
echo "deb http://debian.koha-community.org/koha squeeze-dev main" | sudo tee /etc/apt/sources.list.d/koha.list
wget --quiet -O- "http://debian.koha-community.org/koha/gpg.asc" | sudo apt-key add -

# Make sure we are up to date
# FIXME The upgrade part takes forever to run, uncomment when development is done
# FIXME Or make this step configurable? 
# sudo apt-get update && apt-get upgrade 
sudo apt-get update -q 

# Set the root password for MySQL, so we can do a non-interactive installation 
# From http://www.microhowto.info/howto/perform_an_unattended_installation_of_a_debian_package.html#idp36176
echo mysql-server-5.5 mysql-server/root_password password xyz | sudo debconf-set-selections
echo mysql-server-5.5 mysql-server/root_password_again password xyz | sudo debconf-set-selections

# Install Koha (koha-common) and some other packages
sudo apt-get install -q -y vim cpanminus git git-email mysql-server apache2 koha-common

# Configure Apache
sudo a2enmod rewrite
sudo a2dissite default
echo "Listen 8080" | sudo tee --append "/etc/apache2/ports.conf"
sudo service apache2 restart

# Create a Koha instance
sudo koha-create --create-db --configfile "/vagrant/koha-sites-default.cfg" "$instance_name"

# Configure Git and some repos
git config --global user.name ""$author_name""
git config --global user.email ""$author_email""
git config --global color.status auto
git config --global color.branch auto
git config --global color.diff auto
git config --global diff.tool vimdiff
git config --global difftool.prompt false
git config --global alias.d difftool
git config --global core.whitespace trailing-space,space-before-tab
git config --global apply.whitespace fix

git clone --depth=1 $koha_repo kohaclone
cd kohaclone
if [ $my_repo != '' ]; then
    git remote add $my_repo_name $my_repo
    # FIXME git fetch --all?
fi

# Gitify
cd 
git clone https://github.com/mkfifo/koha-gitify.git gitify
cd gitify
sudo ./koha-gitify "$instance_name" /home/vagrant/kohaclone
sudo service apache2 restart
