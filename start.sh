#!/bin/sh

path=`pwd`
file1=$path/check.sh        #directory cli script
ip_file=$path/ip.txt
output_file=$path/out.txt      # output files
csv_file=$path/csv.txt
file2=$path/input.txt
file3=$path/dbread.txt
file4=$path/update_enable.sh
file5=$path/update_disable.sh
> $output_file
> $csv_file
#/usr/Systems/OTNE_1/script/dbread_pdu > $file3
cat $file3 |awk '{print $5}'|sed 's/TL1//g; s/,//g' > $ip_file

#start cli session to get the shelf config
printf "%s\n" "node,,,ip,,,cardinit asap status,," > $csv_file

Check () {
cat $ip_file | while read ip
do
#ip variable bug fix
target_node_id=`grep "\b$ip\b" $file3 | awk '{print $2}'`
   $file1 $output_file $ip $user $pass
Report
done
}

UpdateEnable () {
cat $ip_file | while read ip
do
#ip variable bug fix
target_node_id=`grep "\b$ip\b" $file3 | awk '{print $2}'`
   $file4 $output_file $ip $user $pass
Report
done
}
UpdateDisable () {
cat $ip_file | while read ip
do
#ip variable bug fix
target_node_id=`grep "\b$ip\b" $file3 | awk '{print $2}'`
   $file5 $output_file $ip $user $pass
Report
done
}
Report () {
header=`echo "$target_node_id" "," "$ip" |  tr -d '\r'`
cardinit_alm_sev=`cat $output_file |grep Sev |awk '{print $4}'`
csv[0]=`echo "$header" | tr -d '\r'`
csv[1]=`echo ","`
csv[2]=`echo "$cardinit_alm_sev"  | tr -d '\r'`
csv[3]=`echo ","`
test=`echo $(echo ${csv[@]})  |  tr ' ' ','`
printf "%s\n" $test >> $csv_file
}

#read input
echo
echo "1830 PSS CardInit Alarm Profile update script"
echo
echo Please enter NE CLI administrator login username :
IFS= read -r cli_user
user="$cli_user"
echo
echo Please enter NE CLI user password :
IFS= read -rs cli_pass
pass="$cli_pass"
echo
echo Please enter Action type :  "check" or "enable" or "disable"  :
echo "Note : enable=warning and disable=notalarmed"
read action_type
echo ActionType : $action_type

if [ $action_type == "check" ]; then
Check
elif [ $action_type == "enable" ]; then
UpdateEnable
elif [ $action_type == "disable" ]; then
UpdateDisable
else
 echo "no action performed"
fi;
exit;
exit;
