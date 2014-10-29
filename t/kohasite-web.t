#!/usr/bin/perl

# Test that Web UI of the sample site that should have been set up is available

use Test::More;
use Test::WWW::Mechanize;
use Modern::Perl;

my $mech = Test::WWW::Mechanize->new;

# Apache

$mech->get_ok( 'http://localhost/', 'Apache OPAC OK' );
$mech->get_ok( 'http://localhost:8080/', 'Apache intranet OK' );

# Plack

$mech->get_ok( 'http://localhost:5000/', 'Plack OPAC OK' );
$mech->get_ok( 'http://localhost:5001/', 'Plack intranet OK' );

done_testing();
