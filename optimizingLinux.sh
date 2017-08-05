#!/bin/bash
#QQ : 691906806   by:seventeenWen
#Date：2017-07-15 Adress:Beijing
#Des:基础优化Linux ShellScripts  Demo001
#Version 1.0

#System env

echo -e "Kernel Version \033[30;37;1m $(uname -r) \033[0m"
echo -e "Hostname       \033[30;37;1m $(uname -n) \033[0m"
echo -e "Linux  Version \033[30;37;1m $(cat /etc/redhat-release) \033[0m"
echo -e "Scripts by     \033[30;37;1m seventeenWen \033[0m"
echo -e "Today is       \033[30;37;1m  $(date +%Y/%m/%d)\033[0m"

#create normal User
normalUserAdd()  {
	flag=$(cat /etc/passwd|grep "$1")
if [ -z $flag ]
	then 
		echo "username is ok: $1"
		return 0
	else
		echo -e "username:\033[30;31;1m 【$1】 \033[0m is exist"
		return 1
fi 
}

#close selinux
closeSELinux() {
sed -i.bak "s#^SELINUX=.*#SELINUX=disabled#g" /etc/selinux/config
#backup /etc/selinux/config
[ -d /myBackup ]&& cp /etc/selinux/config.bak /myBackup/ || mkdir /myBackup;cp /etc/selinux/config.bak /myBackup/
grep "SELINUX=disabled" /etc/selinux/config
setenforce 0
echo "selinux:    【`getenforce`】"
}
closeIptables() {
#close iptables
/etc/init.d/iptables stop
/etc/init.d/iptables stop
echo -e "\033[31;1m$(/etc/init.d/iptables status)\033[0m "
chkconfig iptables off
chkconfig |grep "iptables"
}
#closeSrartService() ｛
#	chkconfig|egrep -v "crond|sshd|network|rsyslog|sysstat"|awk '{print "chkconfig",$1,"off"}'|bash
#｝
synchronizedDate() {
	ntpdate ntp1.aliyun.com
}

main() {
read -p "please input normal username:" normalName
normalUserAdd $normalName
if [ $? -gt 0 ]
	then 
		echo -e "\033[31;5m【error】:user【$normalName】is exist \033[0m "
		exit 0
	else
		useradd $normalName
fi
echo "123456"|passwd $normalName --stdin
closeSELinux
closeIptables
synchronizedDate
}

main






