#!/usr/bin/perl

use strict;
use warnings;

my @arr=`head -1 input.csv`; 

my $content;

print "The array is: " . join($", @arr) . "\n";
exit ;

foreach ( @arr ) {

  $content .= ',' if $content;
    $content .= $_;

      print "$content\n";

}