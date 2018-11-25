#!/usr/bin/env perl

#---------------------------------------------------------------------------------------
# Process from input.csv >system,itam_id,app_ver,deploy_date, hosts ->
#---------------------------------------------------------------------------------------
# This script can handle as variable amount of hosts and will cross reference for the serial
# number of the bios before transacting to service now

# Ver 1.0 - Not Tested with API (pretends)- Nathan C Stott 23/11/2018
# Ver 2.0 - accepts and validates command line args 
#           could work in CRON Nathan C Stott 23/11/2018

use strict;
use warnings;

my $filename=$ARGV[0];
my $path=$ARGV[1];
my $user=$ARGV[2];
my $pass=$ARGV[3];
my $num_args = $#ARGV + 1;
if ($num_args != 4) {
    print "\nUsage: [file_name] [path] [user] [password] \n";
    print "[ERROR]: incorect only $num_args parameters passed! >@ARGV<";
        exit;
}

my $full_path_to_file=$path . "/" . $filename;
open(my $fh, '<:encoding(UTF-8)', $full_path_to_file)
  or die "[ERROR]: Could not open file '$full_path_to_file' $!";

my @data=<$fh>;
my @system=();

my $json_payload="";
my $cont_type="Content-Type: application/json";
my $app_type="Accept: application/json";
my $user_pass="$user" . "$pass";
my $URL="";


foreach my $rec(@data)
{
	chomp $rec;
	my @system = split /,/, $rec;
	$json_payload=process_system(\@system);

	print ">>>>>$json_payload<<<<<<<<<<";
	transact_payload($user_pass,$app_type,$cont_type,$json_payload);
}

sub transact_payload
{
	my $u=shift;
	my $at=shift;
	my $ct=shift;
	my $pl=shift;
	my @ret=();

#       Add  -w "%{http_code}\\n" option in curl for status code response. 
# see  https://stackoverflow.com/questions/29243587/curl-post-request-get-response-and-status-code
        print "curl here->@ret=`curl -v -i --user $u -H $at -H $ct --data $pl -X "$URL"`;"
}


sub process_system
{
	my @array= @{$_[0]};	
	my @hosts=();

	my $system=$array[0];
	my $itam_id=$array[1];
	my $app_ver=$array[2];
	my $env=$array[3];
	my $dep_dt=$array[4];
	my $c=0;
	my $y=0;
	my $query="";
	foreach my $rec(@array)
	{
		if ( $c > 4)
		{
			my $add_host=$array[$c];
			print "DEBUG Adding >$add_host< to @hosts\n";
			push @hosts, $add_host;
			$y++;

		}
		$c++;
	}
	print "DEBUG 0 element of hosts = >$hosts[0]<";

	my $num_hosts = @hosts;
	my $ret_fields="&sysparm_fields=serial_number,name";
	if ($num_hosts == 1)	
	{
		$query="sysparm_query=name%3D" . $hosts[0] . $ret_fields;
	}
	else
	{
		$query="sysparm_query=namein" . join($", @hosts);
		$query =~ s/ /,/g;
		$query .= $ret_fields;

	}
	print "CURL HERE FOR THE RESPONSE X REF host to bios serial with >$query<\n";
	my @response=();
	#----------------------------------------------------------------------------
	# FOR TESING PURPOSES ONLY TO TRY AND PREDICT OUTPUT FROM API (test up to 7 hosts here)
	#-----------------------------------------------------------------------------
	if ($num_hosts == 1)
	{
		@response=`cat pretend_1.sh |grep -i "serial" |cut -d'"' -f4`;
		
	}
	if ($num_hosts == 2)
	{
		@response=`cat pretend_2.sh |grep -i "serial" |cut -d'"' -f4`;

	}
	if ($num_hosts == 3)
	{
		@response=`cat pretend_3.sh |grep -i "serial" |cut -d'"' -f4`;

	}
	if ($num_hosts == 4)
	{
		@response=`cat pretend_4.sh |grep -i "serial" |cut -d'"' -f4`;

	}
	if ($num_hosts == 5)
	{
		@response=`cat pretend_5.sh|grep -i "serial" |cut -d'"' -f4`;

	}
	if ($num_hosts == 6)
	{
		@response=`cat pretend_6.sh |grep -i "serial" |cut -d'"' -f4`;

	}
	if ($num_hosts == 7)
	{
		@response=`cat pretend_7.sh|grep -i "serial" |cut -d'"' -f4`;

	}
	#-----------------------------------------------------------------------------------------
	# End of test CODE (temp)
	#-----------------------------------------------------------------------------------------
	#-----------------------------------------------------------------------------------------
	# Will need to validate the json response here if no 'serial' values then NOT OK!
	my $json_p="";
	#print  "{ \n";
	$json_p =  "{ \n";
	print " \"u_environment\": \"${env}\", \n";
	$json_p .= " \"u_environment\": \"${env}\", \n";
	#print " \"u_business_application_version\": \"${app_ver}\", \n";
	$json_p .= " \"u_business_application_version\": \"${app_ver}\", \n";
	#print " \"u_deployment_date_time\": \"${dep_dt}\", \n";
	$json_p .= " \"u_deployment_date_time\": \"${dep_dt}\", \n";
	#print " \"u_business_application_id\": ${itam_id},\n";
	$json_p .= " \"u_business_application_id\": ${itam_id},\n";
	#print " \"u_deployment_targets\": [{ \n";
	$json_p .= " \"u_deployment_targets\": [{ \n";
	$y=0;
	$c=0;
	foreach my $h(@response)
	{
		chomp $h;
		if ( $c > 0 )
		{
			#print "       {\n";
			$json_p .="       {\n";
		}
		#print "              \"u_bios_serial_number\": \"$h\"\n";
		$json_p .= "              \"u_bios_serial_number\": \"$h\"\n";
		if ( ($num_hosts - 1) ==  $c )
		{
        		#print "         }\n";
        		$json_p .= "         }\n";
		}
		else
		{
        		#print "         },\n";
        		$json_p .= "         },\n";
		}
		$c++;
	}
	#print "   ]\n";
	$json_p .="   ]\n";
	#print "}\n";
	$json_p .="}\n";
	#print "system >$system<\nitam_id >$itam_id<\napp_ver=>$app_ver<\nenv=>$env\n<dep dt=>$dep_dt<\n";
	return $json_p;
}