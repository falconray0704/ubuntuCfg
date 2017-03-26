#!/bin/bash
#/usr/local/kcp-server/kcp-server -l ":47369" -t "127.0.0.1:47147" --key "&Fuckgfw" &
#/opt/gows/src/github.com/xtaci/kcptun/server_linux_amd64 -t "127.0.0.1:47147" -l ":14369" -mode fast2 &
#./client_linux_amd64 -r "23.106.154.150:14369" -l ":47140" -mode fast2 &

ip=`ifconfig | grep "inet addr" | awk '{print $2}' | grep -v 127 | sed 's/addr://'`
echo "Local IP:$ip"

#echo $ACTION

stop()
{
	kcpClients=`ps -ef | grep client_linux_amd64 | grep "mode" | awk '{print $2}'`
	for pid in ${kcpClients}
	do
		#echo ${pid}
		kill -9 ${pid}
	done
}

start()
{
    srvIP=
    if [ -e "./srvIP" ]
    then
        srvIP=`cat ./srvIP`
    fi
    if [ ! -n "$srvIP" ]
    then
        echo "Please input remote kcp server IP:"
        read srvIP
    fi
	declare -i idx=0
	while [ $idx -lt $1 ]
	do
		#echo ${idx}
		p5="1 4"
		p4="2 5"
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
                            #./client_linux_amd64 -r "${srvIP}:${port}" -l ":${port}"  -sndwnd 40960 -rcvwnd 40960 -mode fast3 &
                            ./client_linux_amd64 -r "${srvIP}:${port}" -l ":${port}"  -mode fast3 &
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
