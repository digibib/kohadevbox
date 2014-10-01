#!/usr/bin/perl

use Test::More;
use Test::File;
use Modern::Perl;

my $gitifydir = '/home/vagrant/gitify';
my $gitifyscript = $gitifydir . '/koha-gitify';

dir_exists_ok( $gitifydir, 'gitify directory exists' );
dir_exists_ok( $gitifydir . '/.git', 'gitify directory looks like a Git repo ' );
file_executable_ok( $gitifyscript, 'koha-gitify script exists and is executable' );

done_testing();
