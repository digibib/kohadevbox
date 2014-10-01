#!/usr/bin/perl

# Test the results of installing the koha-common package

use Test::More;
use Test::File;
use Modern::Perl;

# Test the existence of some sample files in different parts of the file system
file_executable_ok( '/usr/sbin/koha-create', 'koha-create exists and is executable' );
file_executable_ok( '/usr/share/koha/bin/stage_file.pl', 'stage_file.pl exists and is executable' );

done_testing();
