#!/usr/bin/perl -Tw

use strict;
use warnings;
use File::Copy;

# Read the file.
open my $rfh,"<","/etc/apache2/sites-available/kohadev.conf" || die "Unable to read kohadev.conf apache configuration file!\n";
my @data = <$rfh>;
close $rfh;

# find the OPAC block create a copy
my @opacblock;
my $flag=0;

foreach my $line (@data) {
    if ($flag==0) {
        if ($line =~ /^#\s*OPAC\s*$/) {
            $flag = 1;
        }
        if ($flag) {
            push @opacblock,$line;
        }
    }
    else {
        if ($line =~ /^#\s*Intranet\s*$/) {
            $flag = 0;
        }
        if ($flag) {
            push @opacblock,$line;
        }
    }
}

# add the SSL lines in;
my @SSLopacblock;
foreach my $line (@opacblock) {

    # just after the AssignUserID line
    if ($line =~ /^\s*AssignUserID\s.*$/) {
        push @SSLopacblock,$line;
        push @SSLopacblock,"\n";
        push @SSLopacblock,"   SSLEngine on\n";
        push @SSLopacblock,"   SSLCertificateFile    /etc/ssl/certs/ssl-cert-snakeoil.pem\n";
        push @SSLopacblock,"   SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key\n";
    }
    # making sure to tweak the port number
    elsif ($line =~ /^<VirtualHost \*:80>/) {
        $line =~ s/80/443/g;
        push @SSLopacblock,$line;
    }
    else {
        push @SSLopacblock,$line;
    }
}

#build full revised data set with the added SSL block
my @reviseddata;
foreach my $line (@data) {
    if ($line =~ /^#\s*OPAC\s*$/) {
        push @reviseddata,@SSLopacblock;
    }
    push @reviseddata,$line;
}

# copy out the original config file.
open my $cfh,">","/etc/apache2/sites-available/kohadev.conf.nossl" || die "Unable to write kohadev.conf.nossl apache configuration file!\n";
print $cfh @data;
close $cfh;

# write out the revised config file.
open my $wfh,">","/etc/apache2/sites-available/kohadev.conf.ssl" || die "Unable to write kohadev.conf.ssl apache configuration file!\n";
print $wfh @reviseddata;
close $wfh;

# overwrite the existing config file.
open my $nfh,">","/etc/apache2/sites-available/kohadev.conf" || die "Unable to write kohadev.conf apache configuration file!\n";
print $nfh @reviseddata;
close $nfh;
