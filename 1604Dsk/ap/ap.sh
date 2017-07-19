#!/bin/bash

apMac="xx:xx:xx:xx:xx:xx"
apName=wlan0
apSSID=piAP
apPwd=piAP

outInterface=eth0

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
	
	cat ./tmpConfigs/NetworkManager.conf
	sudo cp ./tmpConfigs/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
}

hostapd_config()
{
	#cmd="s/interface/interface=${apName}"
	#echo "cmd:${cmd}"

	cp ./configs/hostapd.conf ./tmpConfigs/hostapd.conf
	sed -i "s/interface=wlan0/interface=${apName}/g" ./tmpConfigs/hostapd.conf
	sed -i "s/ssid=piAP/ssid=${apSSID}/g" ./tmpConfigs/hostapd.conf
	sed -i "s/wpa_passphrase=piAP/wpa_passphrase=${apPwd}/g" ./tmpConfigs/hostapd.conf

	cat ./tmpConfigs/hostapd.conf

	sudo cp ./tmpConfigs/hostapd.conf /etc/hostapd/
}

dnsmasq_config()
{
	sudo systemctl disable dnsmasq.service
	
	cp configs/dnsmasq_AP.conf ./tmpConfigs/
	sed -i "s/interface=wlan0/interface=${apName}/g" ./tmpConfigs/dnsmasq_AP.conf
	
	cat ./tmpConfigs/dnsmasq_AP.conf

	sudo cp ./tmpConfigs/dnsmasq_AP.conf /etc/
}

encapsulate_service()
{
	cp configs/AP.service ./tmpConfigs/
	sed -i "s/wlan0/${apName}/g" ./tmpConfigs/AP.service
	
	cat ./tmpConfigs/AP.service

	sudo cp ./tmpConfigs/AP.service /lib/systemd/system/

}

enableAP_service()
{
	sudo systemctl enable AP.service
	#sudo systemctl start AP.service
}

enableAP_forward()
{
	sudo lshw -C network | grep -E "-network|description|logical name|serial"

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
	sudo lshw -C network | grep -E "-network|description|logical name|serial"

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

	#sudo echo 'iptables-restore < /etc/iptables.ipv4.nat' >> /etc/rc.local
	sudo echo 'up iptables-restore < /etc/iptables.ipv4.nat' >> /etc/network/interfaces

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
		encapsulate_service

		echo "Please review configuration before enable AP service."
		echo "Are those correct and reboot for continue?"
		read isCorrect

		if [ ${isCorrect}x = "Y"x ] || [ ${isCorrect}x = "y"x ]; then
			echo "correct"
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
		ps -ef | grep -E ".*hostapd|.*dnsmasq" | grep -v grep
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

