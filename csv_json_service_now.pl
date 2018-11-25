#!/usr/bin/env perl

#---------------------------------------------------------------------------------------
# Process from input.csv >system,itam_id,app_ver,deploy_date, hosts ->
#---------------------------------------------------------------------------------------
# Script to handle as variable amount of hosts and will cross reference to SN API
#  for the serial No: of the BIOS, then transact to SN.
# Currently will do one final payload? 
#---------------------------------------------------------------------------------------

# Ver 1.0 - Not Tested with API (hence pretends_#.sh induce fake JSON)- Nathan C Stott 23/11/2018
#         - accepts and validates command line args 
#         - could work in CRON Nathan C Stott 23/11/2018
#         - can deal with unlimited hosts (variable length CSV)

#To do - Like to use LW agent for curl then use for console.log, otherwise use curl with "-v" 
# Test with API! 

use strict;
use warnings;

my $filename=$ARGV[0];
my $path=$ARGV[1];
my $user=$ARGV[2];
my $pass=$ARGV[3];
my $num_args = $#ARGV + 1;
if ($num_args != 4) {
    print "\nUsage: [file_name] [path] [user] [password] \n";
    print "[ERROR]: incorect only $num_args parameters passed, \nyou passed [@ARGV]\n";
    exit;
}

my $full_path_to_file=$path . "/" . $filename;
open(my $fh, '<:encoding(UTF-8)', $full_path_to_file)
  or die "[ERROR]: Could not open file '$full_path_to_file' $!";

my @data=<$fh>;
my @system=();

my @json_payload=();
my $cont_type="Content-Type: application/json";
my $app_type="Accept: application/json";
my $user_pass="$user" . "$pass";
my $URL="";


foreach my $rec(@data)
{
	chomp $rec;
	my @system = split /,/, $rec;
	push @json_payload ,process_system(\@system);

}

#URL="https://equifax.service-now.com/api/equif/v2/packaging_and_release_api/post_application
#       Add  -w "%{http_code}\\n" option in curl for status code response. ??
# see  https://stackoverflow.com/questions/29243587/curl-post-request-get-response-and-status-code
        #print "curl here->@ret=`curl -v -i --user $u -H $at -H $ct --data $pl -X "$URL"`;"
my @response=$(curl -v -i --user "$userpass" -H "$cont_type" -H "$app_type" -X POST  -data "$(get_serial_bios)"  "$URL");
	print "\n>@json_payload<\n";

close($fh);
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
			push @hosts, $add_host;
			$y++;

		}
		$c++;
	}
	my $num_hosts = @hosts;
	my $ret_fields="&sysparm_fields=serial_number,name";
	if ($num_hosts == 1)	
	{
		$query="https://servicenowdev.equifax.com/api/now/v1/table/cmdb_ci_server?sysparm_query=name%3D" . $hosts[0] . $ret_fields;
	}
	else
	{
		$query="https://servicenowdev.equifax.com/api/now/v1/table/cmdb_ci_server?sysparm_query=namein" . join($", @hosts);
		$query =~ s/ /,/g;
		$query .= $ret_fields;

	}
	#"CURL HERE FOR THE RESPONSE X REF host to bios serial with >$query<\n";
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
	$json_p =  "{ \n";
	$json_p .= " \"u_environment\": \"${env}\", \n";
	$json_p .= " \"u_business_application_version\": \"${app_ver}\", \n";
	$json_p .= " \"u_deployment_date_time\": \"${dep_dt}\", \n";
	$json_p .= " \"u_business_application_id\": ${itam_id},\n";
	$json_p .= " \"u_deployment_targets\": [{ \n";
	$y=0;
	$c=0;
	foreach my $h(@response)
	{
		chomp $h;
		if ( $c > 0 )
		{
			$json_p .="       {\n";
		}
		$json_p .= "              \"u_bios_serial_number\": \"$h\"\n";
		if ( ($num_hosts - 1) ==  $c )
		{
        		$json_p .= "         }\n";
		}
		else
		{
        		$json_p .= "         },\n";
		}
		$c++;
	}
	$json_p .="   ]\n";
	$json_p .="}\n";
	return $json_p;
}