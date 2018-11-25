#!/usr/bin/env bash

# bash scrtipt to log release in service now API.
# need hostname to call the API to get the bios number
# Input from CSV file
# linited to 5 hosts

get_serial_bios()
{
	cat input.csv |while read line
	do
		system=$(echo "$line" |cut -d',' -f1)
		itam_id=$(echo "$line" |cut -d',' -f2)
		app_ver=$(echo "$line" |cut -d',' -f3)
		env=$(echo "$line" |cut -d',' -f4)
		dep_dt=$(echo "$line" |cut -d',' -f5)
		bios1=$(echo "$line" |cut -d',' -f6)
		bios2=$(echo "$line" |cut -d',' -f7)
		bios3=$(echo "$line" |cut -d',' -f8)
		bios4=$(echo "$line" |cut -d',' -f9)
		bios5=$(echo "$line" |cut -d',' -f10)

	query="https://servicenowdev.equifax.com/api/now/v1/table/cmdb_ci_server?sysparm_query=nameIN"
	if [ -z "$bios1" ];then
		query="sysparm_query=name%3D${bios1}&sysparm_fields=serial_number,name"
		#query="https://servicenowdev.equifax.com/api/now/v1/table/cmdb_ci_server?sysparm_query=nameINuicu5lc9a002.app.c9.equifax.com,UICU5LC9A001.app.c9.equifax.com&sysparm_fields=serial_number,name"
	fi

	if  [ -z "$bios4" ] && [ -z "$bios3" ] && [ -z "$bios2"  ] ; then
	         IFS=$'\r\n'  eval "array=($(cat pretend_1.sh|grep -i "serial"|cut -d\" -f4 ))"
		query="sysparm_query=name%3D${bios1}&sysparm_fields=serial_number,name"
	elif [ ! -z "$bios2" ] && [ -z "$bios3" ] ; then
	         IFS=$'\r\n'  eval "array=($(cat pretend_2.sh|grep -i "serial"|cut -d\" -f4 ))"
	         query="https://servicenowdev.equifax.com/api/now/v1/table/cmdb_ci_server?sysparm_query=nameIN${array[0]},${array[1]}&sysparm_fields=serial_number,name"
	elif [ ! -z "$bios3" ] && [  -z "$bios4" ] ; then
	                IFS=$'\r\n'  eval "array=($(cat pretend_3.sh|grep -i "serial"|cut -d\" -f4 ))"
	         query="https://servicenowdev.equifax.com/api/now/v1/table/cmdb_ci_server?sysparm_query=nameIN${array[0]},${array[1]},${array[2]}&sysparm_fields=serial_number,name"
	elif [ ! -z "$bios4" ] && [ -z "$bios5" ]; then
	                IFS=$'\r\n'  eval "array=($(cat pretend_4.sh|grep -i "serial"|cut -d\" -f4 ))"
	         query="https://servicenowdev.equifax.com/api/now/v1/table/cmdb_ci_server?sysparm_query=nameIN${array[0]},${array[1]},${array[2]},${array[3]}&sysparm_fields=serial_number,name"
	else
	                IFS=$'\r\n'  eval "array=($(cat pretend_5.sh|grep -i "serial"|cut -d\" -f4 ))"
	         query="https://servicenowdev.equifax.com/api/now/v1/table/cmdb_ci_server?sysparm_query=nameIN${array[0]},${array[1]},${array[2]},${array[3]},${array[4]}&sysparm_fields=serial_number,name"
	fi

	len=${#array[@]}
	indx=$(expr $len - 1)
	if [ "${len}" -eq 1 ];then

		echo -e  "{ \n"
                echo -e " \"u_environment\": \"${env}\", \n"
                echo -e " \"u_business_application_version\": \"${app_ver}\", \n"
                echo -e " \"u_deployment_date_time\": \"${dep_dt}\", \n"
                echo -e " \"u_business_application_id\": ${itam_id},\n"
                echo -e " \"u_deployment_targets\": [{ \n"
                echo -e "              \"u_bios_serial_number\": \"${array[0]}\"\n"
                echo -e "         }\n"
                echo -e "   ]\n"
                echo -e "}\n"
	else
		echo -e  "{ \n"
                echo -e " \"u_environment\": \"${env}\", \n"
                echo -e " \"u_business_application_version\": \"${app_ver}\", \n"
                echo -e " \"u_deployment_date_time\": \"${dep_dt}\", \n"
                echo -e " \"u_business_application_id\": ${itam_id},\n"
                echo -e " \"u_deployment_targets\": [{ \n"
                echo -e "              \"u_bios_serial_number\": \"${array[0]}\"\n"
                echo -e "         },\n"
		for (( i=1 ; i < $len; i++));
		do
		echo -e "         {\n"
                echo -e "              \"u_bios_serial_number\": \"${array[$i]}\"\n"
		if [ $i -eq "$indx" ]; then
                echo -e "         }\n"
			else
               	echo -e "         },\n"
	fi
		done


                echo -e "   ]\n"
                echo -e "}\n"
	fi
	done
}
cont_type="Content-Type: application/json"
app_type="Accept: application/json"
url_http_production="https://servicenowdev.equifax.com/api/now/v1/table/cmdb_ci_server?"
url_http_test="https://servicenowtest.equifax.com/api/equif/v2/packaging_and_release_api/post_application"
URL="https://jsonplaceholder.typicode.com/posts"
user="admin"
pass="pass"
userpass="$user:$pass"
#response=$(curl -v -i --user "$userpass" -H "$cont_type" -H "$app_type" -X POST  -data "$(get_serial_bios)"  "$URL")
get_serial_bios
	echo ">$response<"



