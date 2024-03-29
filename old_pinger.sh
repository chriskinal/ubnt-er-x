#!/bin/bash
# originial script by @ubnt-stig from community.ubnt.com
# This is my attempt to optimize it.
# add your ping targets here 
targets=( 
   '1.1.1.1'        
   '8.8.8.8'        
   '8.8.4.4' 
   ) 
# latency check (true|false)
latcheck=true
# Jitter check (true|false)
jitcheck=true
# If strictcheck=true then latency and jitter must be over max before failing
strictcheck=true 
# add max latency/jitter here
maxlat=200
maxjit=20

[ $# != 3 ] && echo "Usages: $0 <group> <intf> <status>" exit 1
group=$1
intf=$2
status=$3

for host in "${targets[@]}"
do

pings () {
/bin/ping -n -c 4 -W 1 -w 1 -i 0.2 -I $2 $1 | tail -1 | awk -F '/' '{print $5 "-" $7}'
if [ ${PIPESTATUS[0]} -ne 0 ]; then
return 1
fi
}

results=$(pings "$host" "$intf")
latency=$(echo $results | cut -f1 -d-)
jitter=$(echo $results | cut -f2 -d-)
striplat=$(echo ${latency%.*})
stripjit=$(echo ${jitter%.*})
echo $striplat
echo $stripjit

if [[ ! -z "$striplat" ]] && [[ ! -z "$stripjit" ]]; then
#begin check latency/jitter
echo begin check
[[ $latcheck = "true" && $jitcheck = "false" && $striplat -gt $maxlat ]] && continue
[[ $latcheck = "false" && $jitcheck = "true" && $stripjit -gt $maxjit ]] && continue
[[ $latcheck = "true" && $jitcheck = "true" && ($striplat -gt $maxlat || $stripjit -gt $maxjit) ]] && continue
[[ $strictcheck = "true" && ($striplat -gt $maxlat && $stripjit -gt $maxjit) ]] && continue
echo "end check"
#end check latency/jitter
exit 0

else

exit 1

fi

done