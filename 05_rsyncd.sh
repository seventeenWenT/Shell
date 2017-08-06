#!/bin/bash
#Author: seventeenWen
#Date : 2017/08/05

#chkconfig:  234 66 88
#description : this scripts is rsync chkconfig config 

[ -f /etc/init.d/functions ]&& .  /etc/init.d/functions

RETAVL=0
prog="rsync"

start() {
	if [ ! -f /var/run/rsyncd.pid ];then
		 /usr/bin/rsync --daemon --config=/etc/rsyncd.conf 
	fi 
	RETAVL=$?


	if [ $RETAVL -eq 0 ];then
		action  "starting  $prog ......   "  /bin/true
	else
		action  "starting  $prog ......   "  /bin/false
	fi
	return $RETAVL
}


stop() {
	killproc  /usr/sbin/rsync
	RETAVL=$0i
	sleep 1：
	if [ $RETAVL -eq 0 ];then
		action  "stoping   $prog  ......    "  /bin/true
	else
		action  "stoping   $prog  ......    "  /bin/false
	fi
}

restart() {
	$0 stop
	$0 start
}


case "$1" in 
start)
	start
;;
stop)
	stop
;;
restart|reload)
	restart
;;
*)
	echo "use  (strat|stop|restart)"
	exit 1		
esac