#!/usr/bin/perl

use strict;


# Set files to use, change these to suit your needs
my $oldstatfile = "/var/tmp/dns-old.txt";
my $newstatfile = "/var/cache/bind/named.stats";


# Obtain old DNS stats from stored file
open(OLDF, "$oldstatfile");
my @raw_data = <OLDF>;
close(OLDF);

my $oldsuccess = @raw_data[0];
my $oldfailure = @raw_data[1];

chomp($oldsuccess);
chomp($oldfailure);


# Check if there is data, if not, initialize
if (! $oldsuccess) {
    $oldsuccess = 0;
}

if (! $oldfailure) {
    $oldfailure = 0;
}


# Get new data from file, first clean the stats file and dump new
system("cat /dev/null > $newstatfile");
system("/usr/sbin/rndc stats");
open(NEWF, "$newstatfile");
my @dns_data = <NEWF>;
close(NEWF);

my $newsuccess = 0;
my $newfailure = 0;
my $line;
my $foundsuccess = 0;
my $foundfailure = 0;


foreach $line (@dns_data) {
    if (($line =~ /^success ([0-9]*)/) && ($foundsuccess == 0)) {
	$foundsuccess = 1;
	$newsuccess = $1;
    }

    if (($line =~ /^failure ([0-9]*)/) && ($foundfailure == 0)) {
	$foundfailure = 1;
	$newfailure = $1;
    }
}


# Calculate difference between old and new. Divide by 5 to get per minute
my $diffsuccess = ($newsuccess - $oldsuccess) / 5;
my $difffailure = ($newfailure - $oldfailure) / 5;


# Store new data
open(OLDF, ">$oldstatfile");
print(OLDF "$newsuccess\n$newfailure");
close(OLDF);

# Print difference
print("$diffsuccess \n$difffailure \n");


