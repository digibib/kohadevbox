#!/usr/bin/perl

# Test the setup of apt

use Test::More;
use Test::File;
use Modern::Perl;

file_exists_ok( '/etc/apt/sources.list.d/zebra.list', 'zebra.list exists' );
file_exists_ok( '/etc/apt/sources.list.d/koha.list', 'koha.list exists' );

done_testing();
