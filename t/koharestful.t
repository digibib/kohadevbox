#!/usr/bin/perl

use Test::More;
use Test::File;
use Test::WWW::Mechanize;
use Modern::Perl;

my $mech = Test::WWW::Mechanize->new;

my $kr_dir = '/home/vagrant/koha-restful';
my $kr_script = $kr_dir . '/opac/rest.pl';
my $kr_sym = '/home/vagrant/kohaclone/opac/rest.pl'; # FIXME

dir_exists_ok( $kr_dir, 'koha-restful directory exists' );
dir_exists_ok( $kr_dir . '/.git', 'koha-restful directory looks like a Git repo ' );
file_executable_ok( $kr_script, 'koha-restful script exists and is executable' );

file_exists_ok( $kr_sym, 'koha-restful symbolic link exists' );
file_is_symlink_ok( $kr_sym, 'koha-restful symbolic link is a symlink' );

$mech->get_ok( 'http://localhost/cgi-bin/koha/rest.pl/branches', 'REST API OK' );

done_testing();
