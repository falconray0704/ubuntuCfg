#!/bin/bash
#/usr/local/kcp-server/kcp-server -l ":47369" -t "127.0.0.1:47147" --key "&Fuckgfw" &
#/opt/gows/src/github.com/xtaci/kcptun/server_linux_amd64 -t "127.0.0.1:47147" -l ":14369" -mode fast2 &

#read ACTION
#echo $ACTION

stop()
{
	kcpServers=`ps -ef | grep kcptun | grep server_linux_amd64 | awk '{print $2}'`
	#echo $kcpServers
	for pid in ${kcpServers}
	do
		#echo ${pid}
		kill -9 ${pid}
	done
}

start()
{
	declare -i idx=0
	while [ $idx -lt $1 ]
	do
		#echo ${idx}
		p5="1 4"
		p4="2"
		p3="7"
		p2="3 6 9"
		p1="2 5 8"
		for idx5 in ${p5}
		do
			for idx4 in ${p4}
			do
				for idx3 in ${p3}
				do
					for idx2 in ${p2}
					do
						for idx1 in ${p1}
						do
							port=${idx5}${idx4}${idx3}${idx2}${idx1}
							#echo "port:${port}"
							/opt/gows/src/github.com/xtaci/kcptun/server_linux_amd64 -t "127.0.0.1:47147" -l ":${port}" -mode fast2 &
						done
					done
				done
			done
		done
		idx=${idx}+1
	done
}

case $1 in
	"start") echo "starting"
		start 1
	;;
	"stop") echo "stopping"
		stop
	;;
	"restart") echo "restarting"
	;;
	*) echo "unknow cmd"
esac
