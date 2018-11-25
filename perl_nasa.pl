#!/usr/bin/env perl

use strict;
use warnings;

my @re=`curl -v -w "%{http_code}\\n" https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY`;
my @logic=();


foreach my $line(@re)
{
	#chomp $line;
	#if ( $line =~ /jpg/)
	#{
	#	my @url = split /"/, $line;
	#	print "url=$url[3]\n";
	#	my $cmd="wget $url[3]";
	#	system($cmd);
	#}
	#if ( $line =~ /HTTP/)
	#{
	#	my $http = $line;
	#	print "HTTP >$line<";
	#}
	print "RE:$line\n";
}