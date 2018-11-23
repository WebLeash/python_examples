#!/usr/bin/bash

# bash scrtipt to log release in service now API.
# need hostname to call the API to get the bios number
# Input from CSV file

get_serial_bios_1()
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
	query_1="sysparm_query=name%3D${_h1}&sysparm_fields=serial_number,name"
	URL="${url_http_test}"

#	echo ">$URL<****\n _h4=$_h4"
	#response=$(curl -v -i --user nXs341:FreeSpeach123! -H $app_type -H ${cont_type} -X "$URL")
	#responese=$(cat pretend_1.sh)
	#_bios=$(cat pretend_1.sh |grep -i "serial" |cut -d'"' -f4)

	if  [ -z $_h4 ] && [ -z $_h3 ] && [ -z $_h2  ] ; then
		_bios=$(cat pretend_1.sh |grep -i "serial" |cut -d'"' -f4)
		echo -e  "{ \n"
		echo -e " \"u_environment\": \"${_env}\", \n"
		echo -e " \"u_business_application_version\": \"${_app_ver}\", \n"
		echo -e " \"u_deployment_date_time\": \"${_dep_dt}\", \n"
		echo -e " \"u_business_application_id\": ${_itam_id},\n"
		echo -e " \"u_deployment_targets\": [{ \n"
		echo -e "              \"u_bios_serial_number\": \"${_bios}\"\n"
		echo -e "         }\n"
		echo -e "   ]\n"
		echo -e "}\n"

	elif [ ! -z $_h2 ] && [ -z $_h3 ] ; then
		IFS=$'\r\n' GLOBIGNORE="*" eval 'var2=($(cat pretend_2.sh|grep -i "serial"|cut -d\" -f4 ))'
		echo -e  "{ \n"
		echo -e " \"u_environment\": \"${_env}\", \n"
		echo -e " \"u_business_application_version\": \"${_app_ver}\", \n"
		echo -e " \"u_deployment_date_time\": \"${_dep_dt}\", \n"
		echo -e " \"u_business_application_id\": ${_itam_id},\n"
		echo -e " \"u_deployment_targets\": [{ \n"
		echo -e "              \"u_bios_serial_number\": \"${var2[0]}\"\n"
		echo -e "         },\n"
		echo -e "         {\n"
		echo -e "              \"u_bios_serial_number\": \"${var2[1]}\"\n"
		echo -e "         }\n"
		echo -e "   ]\n"
		echo -e "}\n"

	elif [ ! -z $_h3 ] && [  -z $_h4 ] ; then
		IFS=$'\r\n' GLOBIGNORE="*" eval 'var3=($(cat pretend_3.sh|grep -i "serial"|cut -d\" -f4 ))'
		echo -e  "{ \n"
		echo -e " \"u_environment\": \"${_env}\", \n"
		echo -e " \"u_business_application_version\": \"${_app_ver}\", \n"
		echo -e " \"u_deployment_date_time\": \"${_dep_dt}\", \n"
		echo -e " \"u_business_application_id\": ${_itam_id},\n"
		echo -e " \"u_deployment_targets\": [{ \n"
		echo -e "              \"u_bios_serial_number\": \"${var3[0]}\"\n"
		echo -e "         },\n"
		echo -e "         {\n"
		echo -e "              \"u_bios_serial_number\": \"${var3[1]}\"\n"
		echo -e "         },\n"
		echo -e "         {\n"
		echo -e "              \"u_bios_serial_number\": \"${var3[2]}\"\n"
		echo -e "         }\n"
		echo -e "   ]\n"
		echo -e "}\n"
	else
		IFS=$'\r\n' GLOBIGNORE="*" eval 'var4=($(cat pretend_4.sh|grep -i "serial"|cut -d\" -f4 ))'
		echo -e  "{ \n"
		echo -e " \"u_environment\": \"${_env}\", \n"
		echo -e " \"u_business_application_version\": \"${_app_ver}\", \n"
		echo -e " \"u_deployment_date_time\": \"${_dep_dt}\", \n"
		echo -e " \"u_business_application_id\": ${_itam_id},\n"
		echo -e " \"u_deployment_targets\": [{ \n"
		echo -e "              \"u_bios_serial_number\": \"${var4[0]}\"\n"
		echo -e "         },\n"
		echo -e "         {\n"
		echo -e "              \"u_bios_serial_number\": \"${var4[1]}\"\n"
		echo -e "         },\n"
		echo -e "         {\n"
		echo -e "              \"u_bios_serial_number\": \"${var4[2]}\"\n"
		echo -e "         },\n"
		echo -e "         {\n"
		echo -e "              \"u_bios_serial_number\": \"${var4[3]}\"\n"
		echo -e "         }\n"
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

	payload_json=$(get_serial_bios_1 "$env" "$app_ver" "$dep_dt" "$itam_id" "$bios1" "$bios2" "$bios3" "$bios4")
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
