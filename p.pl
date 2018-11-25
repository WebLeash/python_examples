#!/usr/bin/env perl

use strict;
use warnings;

my $filename="input.csv";
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

my @data=<$fh>;
my @system=();

my $json_payload="";
my $cont_type="Content-Type: application/json";
my $app_type="Accept: application/json";
my $user_pass="test";
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

	print "___pl =>$pl<"
        #@ret=`curl -v -i --user $u -H $at -H $ct --data $pl -X "$URL"`;
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
	# FOR TESING PURPOSES ONLY TO TRY AND PREDICT OUTPUT FROM API
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
		@response=`cat pretend_7.sh`;

	}
	#-----------------------------------------------------------------------------------------
	# End of test CODE (temp)
	#-----------------------------------------------------------------------------------------
	#-----------------------------------------------------------------------------------------
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