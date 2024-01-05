#!/bin/bash
# originial script by @ubnt-stig from community.ubnt.com
# Optimized script by smyers119
# Changed ot latency only by chriskinal
# add your ping targets here 
targets=( 
   '1.1.1.1'        
   '8.8.8.8'        
   '8.8.4.4' 
   ) 
# add max latency here
maxlat=300
maxjit=30

[ $# != 3 ] && echo "Usages: $0 <group> <intf> <status>" exit 1
group=$1
intf=$2
status=$3

for host in "${targets[@]}"
do

pings () {
#/bin/ping -n -c 4 -W 1 -w 1 -i 0.2 -I $2 $1 | tail -1 | awk -F '/' '{print $5 "-" $7}'
/sbin/ping -n -c 4 -W 1 -t 1 -i 0.2 -S $2 $1 | tail -1 | awk -F '/' '{print $5 "-" $7}'
if [ ${PIPESTATUS[0]} -ne 0 ]; then
return 1
fi
}

results=$(pings "$host" "$intf")
latency=$(echo $results | cut -f1 -d-)
jitter=$(echo $results | cut -f2 -d-)
striplat=$(echo ${latency%.*})
stripjit=$(echo ${jitter%.*})
#echo $striplat
#echo $maxlat
#echo $stripjit
#echo $maxjit


if [[ ! -z "$striplat" ]] && [[ ! -z "$stripjit" ]]; then
#begin check latency
#echo "Begin check"

if [[ $striplat -lt $maxlat ]]; then
#echo "Less Than"
exit 0
else
#echo "Greater Than"
exit 1
fi
#echo "end check"
#end check latency
else

exit 1

fi

done
