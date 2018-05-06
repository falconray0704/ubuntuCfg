#!/bin/bash

isConfigSS="N"
isConfigKCP="N"

apMac="xx:xx:xx:xx:xx:xx"
apName=wlan0
apCh=6
apSSID=piAP
apPwd=piAP

ssIP="127.0.0.1"
ssPort=9000
ssrListenPort=62586
ssEncryptMethod="aes-256-cfb"

ssTcpFast="N"
sstPort=9001
sstListenPort=1053
sstListenPort1=1053
sstListenPort2=2053

sstListenPortv1=44221
sstListenPortv2=44222
sstListenPortv3=44223
sstListenPortv4=44224
sstListenPortv5=44225
sstListenPortv6=44226
sstListenPortv7=44227
sstListenPortv8=44228
sstListenPortv9=44229
sstListenPortv10=44210
sstListenPortv11=44211
sstListenPortv12=44212
sstListenPortv13=44213
sstListenPortv14=44214
sstListenPortv15=44215
sstListenPortv16=44216
sstListenPortv17=44217
sstListenPortv18=44218
sstListenPortv19=44219
sstListenPortv20=44220

sstSrvPort1=54001
sstSrvPort2=54002
sstSrvPort3=54003
sstSrvPort4=54004
sstSrvPort5=54005
sstSrvPort6=54006
sstSrvPort7=54007
sstSrvPort8=54008
sstSrvPort9=54009


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
	echo "Please input your AP channel number(eg:6):"
	read apCh
	echo "Please input your AP SSID:"
	read apSSID
	echo "Please input your AP password:"
	read apPwd

	echo "Please input your ss server IP:"
	read ssIP
	echo "Please input your ss-redir local port:"
	read ssrListenPort


	echo "Your AP name is: ${apName}"
	echo "Your AP Mac address is: ${apMac}"
	echo "Your AP channel is: ${apCh}"
	echo "Your AP SSID is: ${apSSID}"
	echo "Your AP password is: ${apPwd}"

	echo "Your server IP is: ${ssIP}"
	echo "Your ss-redir local port is: ${ssrListenPort}"

	echo "Is it correct? [y/N]"
	read isCorrect

	if [ ${isCorrect}x = "Y"x ] || [ ${isCorrect}x = "y"x ]; then
		echo "correct"
	else
		echo "incorrect"
		exit 1
	fi
}

unmanaged_devices()
{
	sudo cp /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf.pkg
	sudo cp /etc/NetworkManager/NetworkManager.conf ./tmpConfigs/NetworkManager.conf

	sed -i 's/.*dns=dnsmasq$/#dns=dnsmasq/' ./tmpConfigs/NetworkManager.conf
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
	sed -i "s/channel=6/channel=${apCh}/g" ./tmpConfigs/hostapd.conf
	sed -i "s/wpa_passphrase=piAP/wpa_passphrase=${apPwd}/g" ./tmpConfigs/hostapd.conf

	echo "================ after config ./tmpConfigs/hostapd.conf start ============================"
	cat ./tmpConfigs/hostapd.conf
	echo "================ after config ./tmpConfigs/hostapd.conf end   ============================"

	#sudo cp ./tmpConfigs/hostapd.conf /etc/hostapd/
}

dnsmasq_config()
{
	sudo systemctl stop dnsmasq.service
	sudo systemctl disable dnsmasq.service
}

dnscrypt_proxy_config()
{
    pushd ~/dnsCryptProxy/
	#sed -i "s/.*server_names =.*/server_names = \['cisco', 'opennic-onic', 'opennic-tumabox', 'scaleway-fr', 'yandex', 'doh-crypto-sx'\]/" dnscrypt-proxy.toml
	sed -i "s/.*listen_addresses =.*/listen_addresses = \['192.168.11.1:53', '127.0.0.1:53', '[::1]:53'\]/" ./dnscrypt-proxy.toml
    popd
}

isc_DHCP_Server_config()
{
    cp ./configs/dhcpd.conf ./tmpConfigs/
    cp ./configs/isc-dhcp-server ./tmpConfigs/

	sed -i "s/INTERFACES=\"\"/INTERFACES=\"${apName}\"/" ./tmpConfigs/isc-dhcp-server

	echo "================ after config ./tmpConfigs/isc-dhcp-server start ============================"
	cat ./tmpConfigs/isc-dhcp-server
	echo "================ after config ./tmpConfigs/isc-dhcp-server end   ============================"
}

enable_DHCP_service()
{
    sudo systemctl start isc-dhcp-server.service
    sudo systemctl enable isc-dhcp-server.service
}

disable_DHCP_service()
{
    sudo systemctl stop isc-dhcp-server.service
    sudo systemctl disable isc-dhcp-server.service
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

service_AP_config()
{
	cp configs/AP.service ./tmpConfigs/
	sed -i "s/wlan0/${apName}/g" ./tmpConfigs/AP.service

	echo "==================== after config ./tmpConfigs/AP.service start ==================="
	cat ./tmpConfigs/AP.service
	echo "==================== after config ./tmpConfigs/AP.service end   ==================="
}

AP_forward_startup_config()
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

	sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

	cp /etc/network/interfaces ./tmpConfigs/
	sed -i '/iptables-restore < \/etc\/iptables.ipv4.nat/d' ./tmpConfigs/interfaces
	#sudo echo 'iptables-restore < /etc/iptables.ipv4.nat' >> /etc/rc.local
	sed -i '$ a up iptables-restore < /etc/iptables.ipv4.nat' ./tmpConfigs/interfaces

	echo "==================== after config ./tmpConfigs/interfaces start ==================="
	cat ./tmpConfigs/interfaces
	echo "==================== after config ./tmpConfigs/interfaces end ==================="

}

ss_AP_forward_startup_config()
{
	sudo lshw -C network | grep -E "-network|description|logical name"

	#echo "Please input your AP device Name:"
	#read apName
	echo "Please input your output deviceName(eg:eth0):"
	read outInterface

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

	sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

	cp /etc/network/interfaces ./tmpConfigs/
	sed -i '/iptables-restore < \/etc\/iptables.ipv4.nat/d' ./tmpConfigs/interfaces
	#sudo echo 'iptables-restore < /etc/iptables.ipv4.nat' >> /etc/rc.local
	sed -i '$ a up iptables-restore < /etc/iptables.ipv4.nat' ./tmpConfigs/interfaces

	echo "==================== after config ./tmpConfigs/interfaces start ==================="
	cat ./tmpConfigs/interfaces
	echo "==================== after config ./tmpConfigs/interfaces end ==================="

}

commit_all_configs()
{
	sudo cp ./tmpConfigs/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
	sudo cp ./tmpConfigs/hostapd.conf /etc/hostapd/
	sudo cp ./tmpConfigs/AP.service /lib/systemd/system/

	sudo cp ./tmpConfigs/interfaces /etc/network/interfaces

    sudo cp ./tmpConfigs/dhcpd.conf /etc/dhcp/
    sudo cp ./tmpConfigs/isc-dhcp-server /etc/default/

}

enableAP_service()
{
	sudo systemctl daemon-reload
	sudo systemctl enable AP.service
}

disableAP_service()
{
	sudo systemctl disable AP.service
	sudo systemctl daemon-reload
}

remove_all_configs()
{

	sudo rm -rf /etc/hostapd/hostapd.conf
	sudo rm -rf /lib/systemd/system/AP.service

	sudo rm -rf /etc/iptables.ipv4.nat

	sudo sed -i '/\[keyfile\]/d' ./tmpConfigs/NetworkManager.conf
	sudo sed -i '/unmanaged-devices/d' ./tmpConfigs/NetworkManager.conf

	sudo sed -i '/unmanaged-devices/d' /etc/NetworkManager/NetworkManager.conf
	sudo sed -i '/iptables-restore < \/etc\/iptables.ipv4.nat/d' /etc/network/interfaces
}

uninstall_all()
{
    disableAP_service
	remove_all_configs

	echo "uninstall finished..."
	echo "press any key to reboot system"

	read rb

	sudo reboot
}

mkdir -p ./tmpConfigs

case $1 in
	"install") echo "Installing..."
		sudo apt-get update
		sudo apt-get install hostapd
        sudo apt-get install isc-dhcp-server

		get_args

		unmanaged_devices
		hostapd_config
		dnsmasq_config
        dnscrypt_proxy_config
        isc_DHCP_Server_config
        service_AP_config

        ss_AP_forward_startup_config

		echo "Please review configuration before enable AP service."
		echo "Are those correct and reboot for continue?[y/N]:"
		read isCorrect

		if [ ${isCorrect}x = "Y"x ] || [ ${isCorrect}x = "y"x ]; then
			echo "correct"
			commit_all_configs
			enableAP_service
            enable_DHCP_service

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
		ps -ef | grep -E ".*hostapd|.*dnsmasq|.*dnscrypt-proxy|.*ss-tunnel|.*chinadns|.*ss-redir|.*client_linux_amd64" | grep -v grep
	;;
	"test") echo "test command..."
        dnscrypt_proxy_config
        exit 1
		get_args
		unmanaged_devices
		#echo "$apName"
		#echo "$apMac"
		unmanaged_devices
		hostapd_config
		dnsmasq_config

	;;
	"uninstall") echo "Uninstalling..."
		uninstall_all
	;;
	*) echo "unknow cmd"
esac

