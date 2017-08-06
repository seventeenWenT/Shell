#!/bin/bash
#Author ： seventeenWen
########################
#					   #
#     rsync install    #
#					   #							
########################


#normal function
[ -f /etc/init.d/functions ]&& . /etc/init.d/functions

function Msg() {
	if [ $? -eq 0 ];
	then
	action "$*"  /bin/true
	else
	action "$*"  /bin/false
	fi
}

#config rsyncd.conf
function touchRsyncdConfig() {
	cat > /etc/rsyncd.conf <<-EOF
	uid = rsync 
	gid = rsync
	use chroot = no 
	max connections = 200 
	timeout = 300  
	pid file = /var/run/rsyncd.pid
	lock file = /var/run/rsync.lock
	log file = /var/log/rsyncd.log
	[backup] 
	path = /backup 
	ignore errors
	read only = false 
	list = false 
	hosts allow = 172.16.1.0/24 
	hosts deny = 0.0.0.0/32
	auth users = rsync_backup 
	secrets file = /etc/rsync.passwd	
	EOF
	
	Msg "Create rsync.conf"   
}

function rsyncConf() {

#2 create rsync User
[ `id rsync|wc -l` -eq 0 ]&&useradd rsync -s /sbin/nologin -M ||id rsync
#3 create backup dir  auth
[ -d /backup ]&& echo "【dir】:backup is exists !"|| mkdir -p /backup 
chown rsync.rsync /backup
#4 create rsync.passwd
[ -f /etc/rsync.passwd ]&&echo "rsync_backup:123456"> /etc/rsync.passwd ||echo "rsync_backup:123456"> /etc/rsync.passwd
chmod 600 /etc/rsync.passwd

[ ! -f /server/scripts/rsyncd ]&&{
echo "/server/scripts/rsyncd is not exists !"
exit 2
}
chmod 755  /server/scripts/rsyncd
\cp -a /server/scripts/rsyncd  /etc/init.d/
sleep 1
ss -lntup |grep "873"
if [ $? -eq 0 ];
then
	echo "rsync is runing! "  >/dev/null
else
	 /etc/init.d/rsyncd restart
fi

/sbin/chkconfig --add rsyncd
/sbin/chkconfig rsyncd on
Msg "rsync"
sleep 1
}


function main(){
touchRsyncdConfig
rsyncConf
}
main

