#!/bin/bash
#/usr/local/kcp-server/kcp-server -l ":47369" -t "127.0.0.1:47147" --key "&Fuckgfw" &

ip=`ifconfig | grep "inet addr" | awk '{print $2}' | grep -v 127 | sed 's/addr://'`
echo "Server IP:$ip"

#read ACTION
#echo $ACTION

stop()
{
	ssServers=`ps -ef | grep ss-server | grep 0.0.0.0 | awk '{print $2}'`
	#echo $kcpServers
	for pid in ${ssServers}
	do
		#echo ${pid}
		kill -9 ${pid}
	done
}

start()
{
	ss-server -s 0.0.0.0 -p 1000 -l 2081 -k "&Fuckgfw" -m aes-256-cfb -a root -u -f /var/run/rw1000.pid&
	ss-server -s 0.0.0.0 -p 2000 -l 2082 -k "&Fuckgfw" -m aes-256-cfb -a root -u -f /var/run/rw2000.pid&
	ss-server -s 0.0.0.0 -p 3000 -l 2083 -k "&Fuckgfw" -m aes-256-cfb -a root -u -f /var/run/rw3000.pid&
	ss-server -s 0.0.0.0 -p 4000 -l 2084 -k "&Fuckgfw" -m aes-256-cfb -a root -u -f /var/run/rw4000.pid&
	ss-server -s 0.0.0.0 -p 5000 -l 2085 -k "&Fuckgfw" -m aes-256-cfb -a root -u -f /var/run/rw5000.pid&
	ss-server -s 0.0.0.0 -p 6000 -l 2086 -k "&Fuckgfw" -m aes-256-cfb -a root -u -f /var/run/rw6000.pid&
	ss-server -s 0.0.0.0 -p 7000 -l 2087 -k "&Fuckgfw" -m aes-256-cfb -a root -u -f /var/run/rw7000.pid&
	ss-server -s 0.0.0.0 -p 8000 -l 2088 -k "&Fuckgfw" -m aes-256-cfb -a root -u -f /var/run/rw8000.pid&
	ss-server -s 0.0.0.0 -p 9000 -l 2089 -k "&Fuckgfw" -m aes-256-cfb -a root -u -f /var/run/rw9000.pid&

	ss-server -s 0.0.0.0 -p 10000 -l 2080 -k "&Fuckgfw" -m aes-256-cfb -a root -u -f /var/run/rw10000.pid&
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
