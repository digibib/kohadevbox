#!/bin/bash

# The commands in this file will always be run after "vagrant up", even if the
# box was previously stopped with "vagrant halt". 

# Run the tests
# (These are not Koha's tests, but the tests provided by kohadevbox, to check
# that we managed to set things up as we should.)
echo "Running some tests to check that we successfully set up Koha..."
cd /vagrant
prove
