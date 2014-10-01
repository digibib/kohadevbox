#!/usr/bin/perl

# Test the setup of Apache (apache2)

use Test::More;
use Test::File;
use Modern::Perl;

my $ports_conf = '/etc/apache2/ports.conf';

file_exists_ok( '/etc/init.d/apache2', '/etc/init.d/apache2 exists' );

file_contains_like( $ports_conf, '/\nListen 80\n/', 'ports.conf contains Listen 80' );
file_contains_like( $ports_conf, '/\nListen 8080\n/', 'ports.conf contains Listen 8080' );

done_testing();
