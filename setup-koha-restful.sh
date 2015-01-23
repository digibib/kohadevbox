#!/bin/bash

# koha-restful
# Clones and configures the REST API from http://git.biblibre.com/biblibre/koha-restful/
# 
# This will only be done if the KOHA_RESTFUL environment variable is set

if [ ! -f /home/vagrant/koha-restful/opac/rest.pl ]; then

    cd
    echo "Setting up koha-restful"
    sudo apt-get install -q -y libcgi-application-dispatch-perl
    git clone http://git.biblibre.com/biblibre/koha-restful.git ~/koha-restful
    sudo ln -s /home/vagrant/koha-restful/Koha/REST    /home/vagrant/kohaclone/Koha/
    sudo ln -s /home/vagrant/koha-restful/opac/rest.pl /home/vagrant/kohaclone/opac/
    sudo cp -r /home/vagrant/koha-restful/etc/rest     /etc/koha/sites/kohadev/

else

    echo "Skipping koha-restful, because KOHA_RESTFUL is not set"

fi
