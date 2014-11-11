#!/bin/bash

# The commands in this file will always be run after "vagrant up", even if the
# box was previously stopped with "vagrant halt". 

# Start Plack
# FIXME https://github.com/digibib/kohadevbox/issues/31
if [ -f '/vagrant/koha.psgi' ]; then
    # Start Plack and send output to /home/vagrant/logs/plack-*.log
    echo "Starting Plack"
    /vagrant/plackup.sh kohadev   >> /home/vagrant/logs/plack-opac.log  2>&1 &
    /vagrant/plackup.sh kohadev i >> /home/vagrant/logs/plack-intra.log 2>&1 &
fi

# Run the tests
# (These are not Koha's tests, but the tests provided by kohadevbox, to check
# that we managed to set things up as we should.)
echo "Running some tests to check that we successfully set up Koha..."
cd /vagrant
prove
