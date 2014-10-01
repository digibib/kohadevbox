#!/usr/bin/perl

use Test::More;
use Test::File;
use Modern::Perl;

my $bzdir = '/home/vagrant/gitbz';
my $bzscript = $bzdir . '/git-bz';
my $bzsym = '/usr/local/bin/git-bz';

dir_exists_ok( $bzdir, 'gitbz directory exists' );
dir_exists_ok( $bzdir . '/.git', 'gitbz directory looks like a Git repo ' );
file_executable_ok( $bzscript, 'git-bz script exists and is executable' );

file_exists_ok( $bzsym, 'git-bz symbolic link exists' );
file_is_symlink_ok( $bzsym, 'git-bz symbolic link is a symlink' );

done_testing();
