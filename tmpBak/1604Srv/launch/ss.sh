#!/bin/bash
#/usr/local/kcp-server/kcp-server -l ":47369" -t "127.0.0.1:47147" --key "&Fuckgfw" &

ip=`ifconfig | grep "inet addr" | awk '{print $2}' | grep -v 127 | sed 's/addr://'`
echo "Server IP:$ip"

#read ACTION
#echo $ACTION

stop()
{
	ssServers=`ps -ef | grep ss-server | grep -v "grep" | awk '{print $2}'`
	#echo $kcpServers
	for pid in ${ssServers}
	do
		#echo ${pid}
		kill -9 ${pid}
	done
}

start()
{
	ss-server -s 0.0.0.0 -p 443 -l 10443 -k "&Fuckgfw" -m chacha20-ietf-poly1305 -a root --fast-open -u -f /var/run/rw10443.pid&
	ss-server -s 0.0.0.0 -p 8080 -l 18080 -k "&Fuckgfw" -m chacha20-ietf-poly1305 -a root --fast-open -u -f /var/run/rw18080.pid&
}

case $1 in
	"start") echo "starting"
		stop
		start 1
	;;
	"stop") echo "stopping"
		stop
	;;
	"restart") echo "restarting"
		stop
		start 1
	;;
	*) echo "unknow cmd"
esac
