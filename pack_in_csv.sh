#!/usr/bin/bash

# bash scrtipt to log release in service now API.
# need hostname to call the API to get the bios number
# Input from CSV file

get_serial_bios()
{
	_env=$1
	_app_ver=$2
	_dep_dt=$3
	_itam_id=$4
	_h1=$5
	_h2=$6
	_h3=$7
	_h4=$8
	cont_type="Content-Type: application/json"
        app_type="Accept: application/json"

	url_http_production="https://servicenowdev.equifax.com/api/now/v1/table/cmdb_ci_server?"
	url_http_test="https://servicenowtest.equifax.com/api/equif/v2/packaging_and_release_api/post_application"
	if [ -z $_h1 ];then
	query_1="sysparm_query=name%3D${_h1}&sysparm_fields=serial_number,name"
	else
	query_2="https://servicenowdev.equifax.com/api/now/v1/table/cmdb_ci_server?sysparm_query=nameINuicu5lc9a002.app.c9.equifax.com,UICU5LC9A001.app.c9.equifax.com&sysparm_fields=serial_number,name"
	fi

	URL="${url_http_test}"

#	echo ">$URL<****\n _h4=$_h4"
	#response=$(curl -v -i --user XXXXXX:XXXXXXXXXXXXXX -H $app_type -H ${cont_type} -X "$URL")
	#responese=$(cat pretend_1.sh)
	#_bios=$(cat pretend_1.sh |grep -i "serial" |cut -d'"' -f4)

	IFS=$'\r\n' eval 'array=($(cat pretend_1.sh|grep -i "serial"|cut -d\" -f4 ))'
	len=${#array[@]}
	indx=$(expr $len - 1)
	if [ ${len} -eq 1 ];then

		echo -e  "{ \n"
                echo -e " \"u_environment\": \"${_env}\", \n"
                echo -e " \"u_business_application_version\": \"${_app_ver}\", \n"
                echo -e " \"u_deployment_date_time\": \"${_dep_dt}\", \n"
                echo -e " \"u_business_application_id\": ${_itam_id},\n"
                echo -e " \"u_deployment_targets\": [{ \n"
                echo -e "              \"u_bios_serial_number\": \"${array[0]}\"\n"
                echo -e "         }\n"
                echo -e "   ]\n"
                echo -e "}\n"
	else
		echo -e  "{ \n"
                echo -e " \"u_environment\": \"${_env}\", \n"
                echo -e " \"u_business_application_version\": \"${_app_ver}\", \n"
                echo -e " \"u_deployment_date_time\": \"${_dep_dt}\", \n"
                echo -e " \"u_business_application_id\": ${_itam_id},\n"
                echo -e " \"u_deployment_targets\": [{ \n"
                echo -e "              \"u_bios_serial_number\": \"${array[0]}\"\n"
                echo -e "         },\n"
		for (( i=1 ; i < $len; i++));
		do
		echo -e "         {\n"
                echo -e "              \"u_bios_serial_number\": \"${array[$i]}\"\n"
		if [ $i -eq $indx ]; then
                echo -e "         }\n"
			else
               	echo -e "         },\n"
	fi
		done


                echo -e "   ]\n"
                echo -e "}\n"
	fi

}

## Presume here we doing from csv file.
cat input.csv |while read line
do
	system=""
	itam_id=""
	env=""
	dept_dt=""
	bios1=""
	bios2=""
	bios3=""
	bios4=""

	system=$(echo $line |cut -d',' -f1)
	itam_id=$(echo $line |cut -d',' -f2)
	app_ver=$(echo $line |cut -d',' -f3)
	env=$(echo $line |cut -d',' -f4)
	dep_dt=$(echo $line |cut -d',' -f5)
	bios1=$(echo $line |cut -d',' -f6)
	bios2=$(echo $line |cut -d',' -f7)
	bios3=$(echo $line |cut -d',' -f8)
	bios4=$(echo $line |cut -d',' -f9)

	echo "sys=$system, itam_id=$itam_id, app_ver=$app_ver, dep_dt=$dep_dt, app id=$app_id, host1=$bios1 , host2=$bios2, host3=$bios3, host4=$bios4"

	get_serial_bios "$env" "$app_ver" "$dep_dt" "$itam_id" "$bios1" "$bios2" "$bios3" "$bios4"
	payload_json=$(get_serial_bios "$env" "$app_ver" "$dep_dt" "$itam_id" "$bios1" "$bios2" "$bios3" "$bios4")
	echo "---------------------------------------------------------"
	echo $payload_json
	echo "---------------------------------------------------------"
done
#env="PROD"
#app_ver="5.0.13-0fbee13"
#dep_dt="2018-06-01 09:40:00"
#app_id="184624990"
#bios1="679504088234234234234234_udlpc19e09sadfsdf"
#bios2="999994088234234234234234_udlpc19e09sadfsdf"
#bios3=""
#bios4=""
#j2 "$env" "$app_ver" "$dep_dt" "$app_id" "$bios1" "$bios2" "$bios3" "$bios4"
