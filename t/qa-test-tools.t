#!/usr/bin/perl

use Test::More;
use Test::File;
use Modern::Perl;

my $qa_test_tools_dir = '/home/vagrant/qa-test-tools';
my $qascript = $qa_test_tools_dir . '/koha-qa.pl';

dir_exists_ok( $qa_test_tools_dir, 'qa-test-tools directory exists' );
dir_exists_ok( $qa_test_tools_dir . '/.git', 'qa-test-tools directory looks like a Git repo ' );
file_executable_ok( $qascript, 'koha-qa.pl script exists and is executable' );

done_testing();
