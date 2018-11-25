#!/usr/bin/env bash


FS=$'\r\n'  eval "array=($(cat input.csv))"

echo "array=${array[@]}"





exit 









line_cnt=0

while :
    do

          read data_line

	  if [ $? -ne 0 ]
           then
                break
          fi

	  data_array[$line_cnt]="$data_line"

	 (( line_cnt++ ))

  done  <  input.csv




   # To verify one line per element, display the contents of one element per line.

   line_num=0

    while [  $line_num  -lt  $line_cnt  ]
    do

        echo "data_array[$line_num]=${data_array[$line_num][0]}"

        (( line_num++ ))

    done

    var=("${data_array[@]:1}")
    echo "var=$var"
    var=${data_array[1,1]}
    echo "VAR=$var"
exit


cat input.csv | while read line; do
 array=(${line//,/ }); 
  echo "${#array[@]} ${array[@]}"; 
done
echo "array=${array[1]}"


exit
c=0
cat input.csv |while read line
do
             array=`echo "$line" |cut -d',' -f1`
             array=`echo "$line" |cut -d',' -f2`
             array=$(echo "$line" |cut -d',' -f3)
             array=$(echo "$line" |cut -d',' -f4)
             array=$(echo "$line" |cut -d',' -f5)
             array=$(echo "$line" |cut -d',' -f6)
             array=$(echo "$line" |cut -d',' -f7)
             array=$(echo "$line" |cut -d',' -f8)
             array=$(echo "$line" |cut -d',' -f9)
       	     array=$(echo "$line" |cut -d',' -f10)
	     c=$(expr $c + 1)
	     echo "array($c) = >$array[$c]<"
done



