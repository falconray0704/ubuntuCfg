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
	ss-server -s 0.0.0.0 -p 54001 -l 2081 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw54001.pid&
	ss-server -s 0.0.0.0 -p 54002 -l 2082 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw54002.pid&
	ss-server -s 0.0.0.0 -p 54003 -l 2083 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw54003.pid&
	ss-server -s 0.0.0.0 -p 54004 -l 2084 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw54004.pid&
	ss-server -s 0.0.0.0 -p 54005 -l 2085 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw54005.pid&
	ss-server -s 0.0.0.0 -p 54006 -l 2086 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw54006.pid&
	ss-server -s 0.0.0.0 -p 54007 -l 2087 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw54007.pid&
	ss-server -s 0.0.0.0 -p 54008 -l 2088 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw54008.pid&
	ss-server -s 0.0.0.0 -p 54009 -l 2089 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw54009.pid&

	ss-server -s 0.0.0.0 -p 10000 -l 3080 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw10000.pid&
	ss-server -s 0.0.0.0 -p 10001 -l 3081 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw10001.pid&
	ss-server -s 0.0.0.0 -p 10002 -l 3082 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw10002.pid&
	ss-server -s 0.0.0.0 -p 10003 -l 3083 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw10003.pid&
	ss-server -s 0.0.0.0 -p 10004 -l 3084 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw10004.pid&
	ss-server -s 0.0.0.0 -p 10005 -l 3085 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw10005.pid&
	ss-server -s 0.0.0.0 -p 10006 -l 3086 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw10006.pid&
	ss-server -s 0.0.0.0 -p 10007 -l 3087 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw10007.pid&
	ss-server -s 0.0.0.0 -p 10008 -l 3088 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw10008.pid&
	ss-server -s 0.0.0.0 -p 10009 -l 3089 -k "&Fuckgfw" -m aes-256-cfb -a root --fast-open -u -f /var/run/rw10009.pid&
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
