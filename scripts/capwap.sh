#!/bin/bash
#
# The AC manipulation script for the openCAPWAP AC
# Usage: ./capwap start|stop|restart
#

#Script Variables
if=eth1
tap=AC_tap
br=bridgeAC
AC=AC;
ACArgs=/home/user/capwap
CWDir=/home/user/git/openCAPWAP/


#The start the CAPWAP AC function
start() {
  echo -n "Starting capwap daemon: $AC"
	"$CWDir$AC" "$CWDir"
	echo "."
	sleep 3
	echo "Setting up the network interfaces"
	dhclient -r $br
	brctl addbr $br
	brctl addif $br $if
	brctl addif $br $tap
	ifconfig $br up
	ifconfig $tap up
	ifconfig $if 0
	ifconfig $tap 0
	dhclient $br
}


#The stop the CAPWAP AC function
stop() {
  echo -n "Stopping capwap daemon: $AC"
		if [[ -z $(ps -ef |grep $AC) ]]
		then 
			 killall $AC
		fi
		echo "."
		echo "Re-initializing the network interfaces"
		dhclient -r $br
		ifconfig $tap down
		ifconfig $br down
		brctl delbr $br
		ifconfig $if down
		sleep 5
		ifconfig $if up
}


#Read the  passed argument to start or stop the service
case "$1" in
	start)
		start
		;;
	stop) 
		stop
		;;
	restart)
		echo "Restarting $AC..."
    echo " "
    stop
    sleep 3
    start
    ;;
	*)
		echo "Usage: ./capwap start|stop|restart"
		exit 1
		;;
	esac
	
