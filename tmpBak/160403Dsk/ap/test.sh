#!/bin/bash


apMac="xx:xx:xx:xx:xx:xx"
apName=wlx6cfdb948369c

ssIP="67.218.129.228"
ssPort=443
ssrListenPort=42581
ssEncryptMethod="aes-256-cfb"

#outInterface=ens33
outInterface=enx9cebe8105d32

get_args()
{
	#iw list
	#lshw -C network
	sudo lshw -C network | grep -E "-network|description|logical name|serial"
	#echo "Please input your AP device Name:"
	#read apName
	#echo "Please input your AP Mac address:"
	#read apMac
	#echo "Please input your AP channel number(eg:6):"
	#read apCh
	#echo "Please input your AP SSID:"
	#read apSSID
	#echo "Please input your AP password:"
	#read apPwd

	echo "Your AP name is: ${apName}"
	#echo "Your AP Mac address is: ${apMac}"
	#echo "Your AP channel is: ${apCh}"
	#echo "Your AP SSID is: ${apSSID}"
	#echo "Your AP password is: ${apPwd}"

	echo "Is it correct? [y/N]"
	read isCorrect

	if [ ${isCorrect}x = "Y"x ] || [ ${isCorrect}x = "y"x ]; then
		echo "correct"
	else
		echo "incorrect"
		exit 1
	fi
}

enableAP_ss_forward()
{

	sudo iptables -t nat -N SHADOWSOCKS

	sudo iptables -t nat -A SHADOWSOCKS -d ${ssIP} -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 10.0.0.0/8 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 169.254.0.0/16 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 172.16.0.0/12 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 224.0.0.0/4 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 240.0.0.0/4 -j RETURN

	sudo iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports ${ssrListenPort}
	sudo iptables -t nat -A PREROUTING -p tcp -j SHADOWSOCKS
	sudo iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS


	#sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

	#sudo echo 'iptables-restore < /etc/iptables.ipv4.nat' >> /etc/rc.local
	#sudo echo 'up iptables-restore < /etc/iptables.ipv4.nat' >> /etc/network/interfaces

}

AP_forward_startup_config()
{
	sudo lshw -C network | grep -E "-network|description|logical name"

	#echo "Please input your output deviceName(eg:eth0):"
	#read outInterface

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

	#sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

	#cp /etc/network/interfaces ./tmpConfigs/
	#sed -i '/iptables-restore < \/etc\/iptables.ipv4.nat/d' ./tmpConfigs/interfaces
	#sudo echo 'iptables-restore < /etc/iptables.ipv4.nat' >> /etc/rc.local
	#sed -i '$ a up iptables-restore < /etc/iptables.ipv4.nat' ./tmpConfigs/interfaces

	#echo "==================== after config ./tmpConfigs/interfaces start ==================="
	#cat ./tmpConfigs/interfaces
	#echo "==================== after config ./tmpConfigs/interfaces end ==================="

}

ss_AP_forward_startup_config()
{
	sudo lshw -C network | grep -E "-network|description|logical name"

	#echo "Please input your AP device Name:"
	#read apName
	#echo "Please input your output deviceName(eg:eth0):"
	#read outInterface

	echo "All AP:${apName} packet will forward to: ${outInterface}"

	echo "Is it correct? [y/N]"
	read isCorrect

	if [ ${isCorrect}x = "Y"x ] || [ ${isCorrect}x = "y"x ]; then
		echo "Continue to config iptable rules...."
	else
		echo "incorrect"
		exit 1
	fi

	sudo iptables -t nat -A POSTROUTING -o ${outInterface} -j MASQUERADE
	sudo iptables -A FORWARD -i ${outInterface} -o ${apName} -m state --state RELATED,ESTABLISHED -j ACCEPT
	sudo iptables -A FORWARD -i ${apName} -o ${outInterface} -j ACCEPT

    enableAP_ss_forward

	#sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

	#cp /etc/network/interfaces ./tmpConfigs/
	#sed -i '/iptables-restore < \/etc\/iptables.ipv4.nat/d' ./tmpConfigs/interfaces
	#sudo echo 'iptables-restore < /etc/iptables.ipv4.nat' >> /etc/rc.local
	#sed -i '$ a up iptables-restore < /etc/iptables.ipv4.nat' ./tmpConfigs/interfaces

	#echo "==================== after config ./tmpConfigs/interfaces start ==================="
	#cat ./tmpConfigs/interfaces
	#echo "==================== after config ./tmpConfigs/interfaces end ==================="

}

#AP_forward_startup_config
ss_AP_forward_startup_config



