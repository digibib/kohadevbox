#!/bin/bash

# Get the configuration variables
source "/vagrant/config.cfg"
KOHACLONE="/home/vagrant/kohaclone"

# Add some more sources to apt
echo "deb http://ftp.indexdata.dk/debian wheezy main" | sudo tee /etc/apt/sources.list.d/zebra.list
wget --quiet -O- "http://ftp.indexdata.dk/debian/indexdata.asc" | sudo apt-key add -
echo "deb http://debian.koha-community.org/koha squeeze-dev main" | sudo tee /etc/apt/sources.list.d/koha.list
wget --quiet -O- "http://debian.koha-community.org/koha/gpg.asc" | sudo apt-key add -

# Create a directory for logs
mkdir ~/logs

# Make sure we are up to date
# FIXME The upgrade part takes forever to run, uncomment when development is done
# FIXME Or make this step configurable? 
# sudo apt-get update && apt-get upgrade 
sudo apt-get update -q 

# Do not allow ssh to pass locale environment variables into the box. If we
# allow this, users will carry the locale settings from their host computer into
# the box, and Debian will complain about the locale not being installed (if it
# is something other than English, at least).
sudo perl -pi -e 's/AcceptEnv LANG LC_\*/# AcceptEnv LANG LC_\*/g' '/etc/ssh/sshd_config'
sudo service ssh reload

# Source a kohadevbox file from .bashrc, where we can put things like aliases
echo "source /vagrant/kohadevbox-bashrc" >> "/home/vagrant/.bashrc"

# Set the root password for MySQL, so we can do a non-interactive installation 
# From http://www.microhowto.info/howto/perform_an_unattended_installation_of_a_debian_package.html#idp36176
echo mysql-server-5.5 mysql-server/root_password password xyz | sudo debconf-set-selections
echo mysql-server-5.5 mysql-server/root_password_again password xyz | sudo debconf-set-selections

# Install Koha (koha-common) and some other packages
sudo apt-get install -q -y vim cpanminus git git-email mysql-server apache2 koha-common

# Install some packages needed for running tests of the Vagrant setup (found in /vagrant/t/)
sudo apt-get install -q -y libtest-file-perl

# Configure Apache
sudo a2enmod rewrite
sudo a2dissite default
echo "Listen 8080" | sudo tee --append "/etc/apache2/ports.conf"
sudo service apache2 restart

# Create a Koha instance
if [ -f '/vagrant/koha-sites.cfg' ]; then
    sudo koha-create --create-db --configfile "/vagrant/koha-sites.cfg" "$instance_name"
else
    echo "**** /vagrant/koha-sites.cfg does not exist! Unable to create a Koha instance without it. ****"
    exit;
fi

# If SYNC_REPO was set during "vagrant up", there will already be a repo in
# $KOHACLONE and we skip the cloning and "remote add" steps
if [ ! -d "$KOHACLONE" ]; then

    # Clone the official Koha repo
    git clone --depth=1 $koha_repo $KOHACLONE
    cd $KOHACLONE
    # Add the users repo as a remote, if it is set in the config file
    if [ $my_repo != '' ]; then
        git remote add $my_repo_name $my_repo
        # FIXME git fetch --all?
    fi

fi

# Check if the user wants to run the webinstaller or not
if [ $skip_webinstaller == 1 ]; then

    # Load SQL manually, so we don't have to run through the webinstaller
    for file in $KOHACLONE/installer/data/mysql/kohastructure.sql $KOHACLONE/installer/data/mysql/sysprefs.sql $KOHACLONE/installer/data/mysql/$installer_lang/*/*.sql $KOHACLONE/installer/data/mysql/$installer_lang/marcflavour/$installer_marcflavour/*/*.sql
    do
	    echo "Loading $file"
	    sudo koha-mysql "$instance_name" < $file
    done
    # Set the version number
    KOHAVERSION=$( perl -e "do '$KOHACLONE/kohaversion.pl'; print kohaversion();" )
    # Remove all periods from the version number
    KOHAVERSION=$( echo $KOHAVERSION | tr -d . )
    # Insert a period after the first digit
    KOHAVERSION=$( echo $KOHAVERSION | sed 's/^\(.\{1\}\)/\1./' )
    echo "Setting Version = $KOHAVERSION"
    # Insert the version number into the database
    echo "INSERT INTO systempreferences SET variable = 'Version', value = '$KOHAVERSION';" | sudo koha-mysql "$instance_name"

    # Set the marcflavour syspref based on the installer_marcflavour config setting
    installer_marcflavour="${installer_marcflavour^^}"
    echo "INSERT INTO systempreferences SET variable = 'marcflavour', value = '$installer_marcflavour';" | sudo koha-mysql "$instance_name"

    # Load our custom SQL (this should only be run after the webinstaller)
    if [ -f '/vagrant/custom.sql' ]; then
        sudo koha-mysql "$instance_name" < "/vagrant/custom.sql"
    else
        echo "/vagrant/custom.sql does not exist!"
    fi

fi

# Configure Git and some repos
git config --global user.name ""$author_name""
git config --global user.email ""$author_email""
git config --global color.status auto
git config --global color.branch auto
git config --global color.diff auto
git config --global diff.tool vimdiff
git config --global difftool.prompt false
git config --global alias.d difftool
# Allows usage like git qa <bugnumber> to set up a branch based on master and fetch patches for <bugnumber> from bugzilla
git config --global alias.qa '!sh -c "git fetch origin master && git rebase origin/master && git checkout -b qa-$1 origin/master && git bz apply $1"' -
# Allows usage like git qa-tidy <bugnumber> to remove a qa branch when you are through with it
git config --global alias.qa-tidy '!sh -c "git checkout master && git branch -D qa-$1"' -
git config --global core.whitespace trailing-space,space-before-tab
git config --global apply.whitespace fix

# Gitify
cd 
git clone https://github.com/mkfifo/koha-gitify.git gitify
cd gitify
sudo ./koha-gitify "$instance_name" $KOHACLONE
sudo service apache2 restart

# Git bz
# http://wiki.koha-community.org/wiki/Git_bz_configuration
cd
git clone $gitbz_repo gitbz
cd gitbz/
git checkout -b fishsoup origin/fishsoup
sudo ln -s /home/vagrant/gitbz/git-bz /usr/local/bin/git-bz
cd $KOHACLONE
git config bz.default-tracker bugs.koha-community.org
git config bz.default-product Koha
git config --global bz-tracker.bugs.koha-community.org.path /bugzilla3
git config --global bz-tracker.bugs.koha-community.org.bz-user $bugz_user
git config --global bz-tracker.bugs.koha-community.org.bz-password $bugz_pass

# Koha QA Tools
if [ ! -d "/home/vagrant/qa-test-tools/" ]; then

    cd
    git clone $qatools_repo
    cd qa-test-tools/
    echo "*** qa-test-tools from packages"
    sudo apt-get install -q -y libfile-chdir-perl libgit-repository-perl liblist-compare-perl libmoo-perl libperl-critic-perl libsmart-comments-perl
    echo "*** qa-test-tools from CPAN"
    cat ./perl-deps | sudo cpanm  --quiet --notest
    ln -s /home/vagrant/qa-test-tools/perlcriticrc ~/.perlcriticrc
    export PERL5LIB="${PERL5LIB}":/home/vagrant/qa-test-tools/
    alias qa="/home/vagrant/qa-test-tools/koha-qa.pl"

fi

# Plack
# http://wiki.koha-community.org/wiki/Plack
# We run Plack off the same code as the one Apache runs off. This way, people
# can choose to look at Koha by way of either Apache or Plack, without any
# extra fiddling or tweaking. If it turns out to be a bad idea (e.g. because
# the two methods are interfering with each other) we can make it configurable
# later.
if [ -f '/vagrant/koha.psgi' ]; then
    sudo apt-get install -q -y libplack-perl libcgi-emulate-psgi-perl libcgi-compile-perl starman libdevel-size-perl
    sudo cpanm --quiet --notest CGI::Compile Module::Versions Plack::Middleware::Debug Plack::Middleware::Static::Minifier Plack::Middleware::Debug::DBIProfile Plack::Middleware::Debug::Profiler::NYTProf
    # Plack will be started from the run_always.sh script
else
    echo "Skipping Plack because /vagrant/koha.psgi does not exist"
fi
# FIXME https://github.com/digibib/kohadevbox/issues/31
# An alternative approach to implementing Plack would be to use this code:
# git clone git://git.catalyst.net.nz/koha-plack.git
# At the moment, this does not work on gitified Koha instances. We might want to
# make sure it does and switch to this in the future. It does provide some nice
# scripts for starting/stopping Starman etc.
