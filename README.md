Preserving instructions from https://community.ui.com/questions/WAN-load-balance-script-option/07b7b656-9f48-4708-bb2f-69cb8d2de702#answer/113836c7-4f17-40c4-8af0-83dc085242b7

copy code into sudo vi /config/scripts/pinger.sh

sudo chmod +x /config/scripts/pinger

Then you need to find out which load balance group and network interface is the primary

Login to ssh
type configure
show
use the vi window to find load-balance

In this example, group=wan_failover, interface=eth2
We have to change how the “route-test” works to instead use our script, and we have to commit and save it
configure
edit load-balance group <name> interface <name> route-test
set type script /config/scripts/pinger.sh
top
commit
save
exit
In our example configure
edit load-balance group wan_failover interface eth2 route-test
set type script /config/scripts/pinger.sh
top
commit
save
exit
There is a chance after updates this script will be lost and will need to be added again
To test if it’s working use show load-balance watchdog
