#!/bin/bash

isConfigSS="N"

apMac="xx:xx:xx:xx:xx:xx"
apName=wlan0
apSSID=piAP
apPwd=piAP

ssIP="127.0.0.1"
ssPort=9000

sstPort=9001
sstListenPort=1020

outInterface=eth0

get_ssArgs()
{
	echo "Please input your SS server IP:"
	read ssIP
	echo "Please input your SS server Port:"
	read ssPort
	echo "Please input your ss-tunnel Port:"
	read sstPort

	echo "Your SS IP:${ssIP} Port:${ssPort} ss-tunnel Port:${sstPort}"

	echo "Is it correct? [y/N]"
	read isCorrect

	if [ ${isCorrect}x = "Y"x ] || [ ${isCorrect}x = "y"x ]; then
		echo "Continue to config iptable rules...."
	else
		#echo "incorrect"
		exit 1
	fi

}

get_args()
{
	#iw list
	#lshw -C network
	sudo lshw -C network | grep -E "-network|description|logical name|serial"
	echo "Please input your AP device Name:"
	read apName
	echo "Please input your AP Mac address:"
	read apMac
	echo "Please input your AP SSID:"
	read apSSID
	echo "Please input your AP password:"
	read apPwd

	echo "Your AP name is: ${apName}"
	echo "Your AP Mac address is: ${apMac}"
	echo "Your AP SSID is: ${apSSID}"
	echo "Your AP password is: ${apPwd}"

	echo "Is it correct? [y/N]"
	read isCorrect

	if [ ${isCorrect}x = "Y"x ] || [ ${isCorrect}x = "y"x ]; then
		echo "correct"
	else
		#echo "incorrect"
		exit 1
	fi
}

unmanaged_devices()
{
	sudo cp /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf.pkg
	sudo cp /etc/NetworkManager/NetworkManager.conf ./tmpConfigs/NetworkManager.conf

	sed -i 's/dns=dnsmasq$/#dns=dnsmasq/' ./tmpConfigs/NetworkManager.conf
	sed -i '/\[keyfile\]/d' ./tmpConfigs/NetworkManager.conf
	sed -i '/unmanaged-devices/d' ./tmpConfigs/NetworkManager.conf

	echo "[keyfile]" >> ./tmpConfigs/NetworkManager.conf 
	echo "unmanaged-devices=mac:${apMac}" >> ./tmpConfigs/NetworkManager.conf 
	
	echo "============= after config ./tmpConfigs/NetworkManager.conf start ====================="
	cat ./tmpConfigs/NetworkManager.conf
	echo "============= after config ./tmpConfigs/NetworkManager.conf end   ====================="
	#sudo cp ./tmpConfigs/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
}

hostapd_config()
{
	#cmd="s/interface/interface=${apName}"
	#echo "cmd:${cmd}"

	cp ./configs/hostapd.conf ./tmpConfigs/hostapd.conf
	sed -i "s/interface=wlan0/interface=${apName}/g" ./tmpConfigs/hostapd.conf
	sed -i "s/ssid=piAP/ssid=${apSSID}/g" ./tmpConfigs/hostapd.conf
	sed -i "s/wpa_passphrase=piAP/wpa_passphrase=${apPwd}/g" ./tmpConfigs/hostapd.conf

	echo "================ after config ./tmpConfigs/hostapd.conf start ============================"
	cat ./tmpConfigs/hostapd.conf
	echo "================ after config ./tmpConfigs/hostapd.conf end   ============================"

	#sudo cp ./tmpConfigs/hostapd.conf /etc/hostapd/
}

dnsmasq_config()
{
	sudo systemctl disable dnsmasq.service
	
	cp configs/dnsmasq_AP.conf ./tmpConfigs/
	sed -i "s/interface=wlan0/interface=${apName}/g" ./tmpConfigs/dnsmasq_AP.conf
	
	echo "================= after config ./tmpConfigs/dnsmasq_AP.conf start ======================="
	cat ./tmpConfigs/dnsmasq_AP.conf
	echo "================= after config ./tmpConfigs/dnsmasq_AP.conf end   ======================="

	#sudo cp ./tmpConfigs/dnsmasq_AP.conf /etc/
}

enableAP_ss_forward()
{

	sudo iptables -t nat -N SHADOWSOCKS

	sudo iptables -t nat -A SHADOWSOCKS -d ${ssIP}-j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 10.0.0.0/8 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 169.254.0.0/16 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 172.16.0.0/12 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 224.0.0.0/4 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 240.0.0.0/4 -j RETURN

	sudo iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports ${ssPort}
	sudo iptables -t nat -A PREROUTING -p tcp -j SHADOWSOCKS
	sudo iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS


	sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

	#sudo echo 'iptables-restore < /etc/iptables.ipv4.nat' >> /etc/rc.local
	#sudo echo 'up iptables-restore < /etc/iptables.ipv4.nat' >> /etc/network/interfaces

}

service_chinadns_config()
{
	cp configs/chinaDns.service ./tmpConfigs/
	sed -i "s/1053/${sstPort}/g" ./tmpConfigs/chinaDns.service
	
	echo "=================== after config ./tmpConfigs/chinaDns.service start ================="
	cat ./tmpConfigs/chinaDns.service
	echo "=================== after config ./tmpConfigs/chinaDns.service end ================="
}

service_sstunel_config()
{
	cp configs/ss-tunnel.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel.service
	sed -i "s/9001/${sstPort}/g" ./tmpConfigs/ss-tunnel.service
	
	echo "=================== after config ./tmpConfigs/ss-tunnel.service start ================="
	cat ./tmpConfigs/ss-tunnel.service
	echo "=================== after config ./tmpConfigs/ss-tunnel.service end ================="
}

service_AP_config()
{
	cp configs/AP.service ./tmpConfigs/
	sed -i "s/wlan0/${apName}/g" ./tmpConfigs/AP.service

	echo "==================== after config ./tmpConfigs/AP.service start ==================="
	cat ./tmpConfigs/AP.service
	echo "==================== after config ./tmpConfigs/AP.service end   ==================="
}

ss_config()
{
	get_ssArgs
	service_sstunel_config
	service_chinadns_config
}

encapsulate_service()
{

	echo "Do you want to config SS?[y/N]:"
	read isConfigSS

	if [ ${isConfigSS}x = "Y"x ] || [ ${isConfigSS}x = "y"x ]; then
		ss_config
	fi
	
	service_AP_config

	#sudo cp ./tmpConfigs/AP.service /lib/systemd/system/

}

enableAP_forward()
{
	sudo lshw -C network | grep -E "-network|description|logical name"

	echo "Please input your output deviceName(eg:eth0):"
	read outInterface

	echo "All AP packet will forward to: ${outInterface}"

	echo "Is it correct? [y/N]"
	read isCorrect

	if [ ${isCorrect}x = "Y"x ] || [ ${isCorrect}x = "y"x ]; then
		echo "Continue to config iptable rules...."
	else
		#echo "incorrect"
		exit 1
	fi

	sudo iptables -F  
	sudo iptables -X  
	sudo iptables -t nat -F  
	sudo iptables -t nat -X  
	sudo iptables -t nat -A POSTROUTING -o ${outInterface} -j MASQUERADE 
}

enableAP_forward_startup()
{
	sudo lshw -C network | grep -E "-network|description|logical name"

	echo "Please input your AP device Name:"
	read apName
	echo "Please input your output deviceName(eg:eth0):"
	read outInterface

	echo "All AP:${apName} packet will forward to: ${outInterface}"

	echo "Is it correct? [y/N]"
	read isCorrect

	if [ ${isCorrect}x = "Y"x ] || [ ${isCorrect}x = "y"x ]; then
		echo "Continue to config iptable rules...."
	else
		#echo "incorrect"
		exit 1
	fi

	sudo iptables -t nat -A POSTROUTING -o ${outInterface} -j MASQUERADE  
	sudo iptables -A FORWARD -i ${outInterface} -o ${apName} -m state --state RELATED,ESTABLISHED -j ACCEPT  
	sudo iptables -A FORWARD -i ${apName} -o ${outInterface} -j ACCEPT 

	sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

	sed -i '/iptables-restore < \/etc\/iptables.ipv4.nat/d' /etc/network/interfaces
	#sudo echo 'iptables-restore < /etc/iptables.ipv4.nat' >> /etc/rc.local
	sudo echo 'up iptables-restore < /etc/iptables.ipv4.nat' >> /etc/network/interfaces

}

commit_all_configs()
{
	sudo cp ./tmpConfigs/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
	sudo cp ./tmpConfigs/hostapd.conf /etc/hostapd/
	sudo cp ./tmpConfigs/dnsmasq_AP.conf /etc/
	sudo cp ./tmpConfigs/AP.service /lib/systemd/system/
	if [ ${isConfigSS}x = "Y"x ] || [ ${isConfigSS}x = "y"x ]; then
		sudo cp ./tmpConfigs/ss-tunnel.service /lib/systemd/system/
		sudo cp ./tmpConfigs/chinaDns.service /lib/systemd/system/
	fi
}

enableAP_service()
{
	sudo systemctl daemon-reload	

	sudo systemctl enable AP.service
	if [ ${isConfigSS}x = "Y"x ] || [ ${isConfigSS}x = "y"x ]; then
		sudo systemctl enable ss-tunnel.service
		sudo systemctl enable chinaDns.service
	fi
}

if [ $UID -ne 0 ]
then
    echo "Superuser privileges are required to run this script."
    echo "e.g. \"sudo $0\""
    exit 1
fi

mkdir -p ./tmpConfigs

case $1 in
	"install") echo "Installing..."
		sudo apt-get update
		sudo apt-get install hostapd dnsmasq

		get_args

		unmanaged_devices
		hostapd_config
		dnsmasq_config
		enableAP_forward_startup
		encapsulate_service


		echo "Please review configuration before enable AP service."
		echo "Are those correct and reboot for continue?"
		read isCorrect

		if [ ${isCorrect}x = "Y"x ] || [ ${isCorrect}x = "y"x ]; then
			echo "correct"
			commit_all_configs
			enableAP_service
			
			sudo reboot
		else
			#echo "incorrect"
			exit 1
		fi

	;;
	"configIptables") echo "Configuring iptables..."
		enableAP_forward
	;;
	"configAutoIptables") echo "Configuring auto iptables..."
		#sudo apt-get install iptables-persistent
		enableAP_forward_startup
	;;
	"check") echo "Checking AP services..."
		ps -ef | grep -E ".*hostapd|.*dnsmasq|.*ss-tunnel|.*chinadns" | grep -v grep
	;;
	"test") echo "test command..."
		#unmanaged_devices
		get_args
		#echo "$apName"
		#echo "$apMac"
		unmanaged_devices
		hostapd_config
		dnsmasq_config
		encapsulate_service

	;;
	*) echo "unknow cmd"
esac

