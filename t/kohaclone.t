#!/usr/bin/perl

# Test the Koha Git repo that should be in the home dir of the vagrant user

use Test::More;
use Test::File;
use Modern::Perl;

my $kohaclonedir = '/home/vagrant/kohaclone';
my $sample_script = $kohaclonedir . '/koha_perl_deps.pl';

dir_exists_ok( $kohaclonedir, 'kohaclone directory exists' );
dir_exists_ok( $kohaclonedir . '/.git', 'kohaclone directory looks like a Git repo ' );
file_executable_ok( $sample_script, "$sample_script exists and is executable" );

done_testing();
