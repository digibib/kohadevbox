#!/usr/bin/perl

# Test the sample site that should have been set up, called kohadev

use Test::More;
use Test::File;
use Modern::Perl;

my $site_name = 'kohadev';
my $site_dir = '/etc/koha/sites/' . $site_name;
my $site_conf = $site_dir . '/koha-conf.xml';

dir_exists_ok( $site_dir, 'site directory exists' );
file_exists_ok( $site_conf, "$site_conf exists" );

file_exists_ok( '/etc/apache2/sites-enabled/' . $site_name . '.conf', "Apache site config exists" );

dir_exists_ok( '/var/log/koha/' . $site_name, 'logs directory exists' );
dir_exists_ok( '/var/spool/koha/' . $site_name, 'spool directory exists' );
dir_exists_ok( '/var/lock/koha/' . $site_name, 'lock directory exists' );

done_testing();
