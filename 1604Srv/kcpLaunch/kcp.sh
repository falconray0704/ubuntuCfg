#!/bin/bash
#/usr/local/kcp-server/kcp-server -l ":47369" -t "127.0.0.1:47147" --key "&Fuckgfw" &
#/opt/gows/src/github.com/xtaci/kcptun/server_linux_amd64 -t "127.0.0.1:47147" -l ":14369" -mode fast2 &

ip=`ifconfig | grep "inet addr" | awk '{print $2}' | grep -v 127 | sed 's/addr://'`
echo "Server IP:$ip"

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
        echo "{" > /run/gui-config.json
        echo "\"configs\" : [" >> /run/gui-config.json

	declare -i idx=0
	while [ $idx -lt $1 ]
	do
		#echo ${idx}
		p5="5 2"
		p4="7 5 2 6"
		p3="4"
		p2="2 8"
		p1="3 9"
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
							#/opt/gows/src/github.com/xtaci/kcptun/server_linux_amd64 -t "127.0.0.1:10000" -l ":${port}" -sndwnd 40960 -rcvwnd 40960 -mode fast3 &
							/opt/gows/src/github.com/xtaci/kcptun/server_linux_amd64 -t "127.0.0.1:10000" -l ":${port}" -mode fast3 &

							echo "{" >> /run/gui-config.json
							echo "\"server\" : \"$ip\"," >> /run/gui-config.json
							echo "\"server_port\" : ${port}," >> /run/gui-config.json
							echo "\"password\" : \"&Fuckgfw\"," >> /run/gui-config.json
							echo "\"method\" : \"aes-256-cfb\"," >> /run/gui-config.json
							echo "\"remarks\" : \"\"}" >> /run/gui-config.json
							echo "," >> /run/gui-config.json
							sync
						done
					done
				done
			done
		done
		idx=${idx}+1
	done
	port=20000
	/opt/gows/src/github.com/xtaci/kcptun/server_linux_amd64 -t "127.0.0.1:10000" -l ":${port}" -mode fast3 &

	echo "]," >> /run/gui-config.json
        echo "\"strategy\" : \"com.shadowsocks.strategy.ha\"," >> /run/gui-config.json
        echo "\"index\" : -1," >> /run/gui-config.json
        echo "\"global\" : false," >> /run/gui-config.json
        echo "\"enabled\" : false," >> /run/gui-config.json
        echo "\"shareOverLan\" : false," >> /run/gui-config.json
        echo "\"isDefault\" : false," >> /run/gui-config.json
        echo "\"localPort\" : 1080," >> /run/gui-config.json
        echo "\"pacUrl\" : null," >> /run/gui-config.json
        echo "\"useOnlinePac\" : false," >> /run/gui-config.json
        echo "\"availabilityStatistics\" : false}" >> /run/gui-config.json

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
