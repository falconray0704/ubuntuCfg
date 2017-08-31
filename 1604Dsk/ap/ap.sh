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

kcpPort=52483

outInterface=eth0

get_ssArgs()
{
	echo "Please input your SS server IP:"
	read ssIP
	echo "Please input your SS server Port:"
	read ssPort
	#echo "Please input your ss-tunnel Port:"
	#read sstPort
	echo "Enable ss-redir tcp fast open[y/N]:"
	read ssTcpFast

	echo "Do you want to config KCP tunnel?[y/N]:"
	read isConfigKCP

	if [ ${isConfigKCP}x = "Y"x ] || [ ${isConfigKCP}x = "y"x ]; then
		echo "Please input your KCP server Port(eg:52483):"
		read kcpPort
		
		echo "Your KCP server port is ${kcpPort}"
	fi
	

	#echo "Your SS IP:${ssIP} Port:${ssPort} ss-tunnel Port:${sstPort} ssTcpFast:${ssTcpFast}"
	echo "Your SS IP:${ssIP} Port:${ssPort} ssTcpFast:${ssTcpFast}"

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
	echo "Please input your AP channel number(eg:6):"
	read apCh
	echo "Please input your AP SSID:"
	read apSSID
	echo "Please input your AP password:"
	read apPwd

	echo "Your AP name is: ${apName}"
	echo "Your AP Mac address is: ${apMac}"
	echo "Your AP channel is: ${apCh}"
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
	sed -i "s/channel=6/channel=${apCh}/g" ./tmpConfigs/hostapd.conf
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

service_kcp_config()
{
	cp configs/kcp-tunnel.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/kcp-tunnel.service
	sed -i "s/9001/${kcpPort}/g" ./tmpConfigs/kcp-tunnel.service
	
	echo "=================== after config ./tmpConfigs/ss-redir.service start ================="
	cat ./tmpConfigs/ss-redir.service
	echo "=================== after config ./tmpConfigs/ss-redir.service end ================="
}

service_ss_redir_config()
{
	cp configs/ss-redir.service ./tmpConfigs/
	if [ ${isConfigKCP}x = "Y"x ] || [ ${isConfigKCP}x = "y"x ]; then
		sed -i "s/9001/61586/g" ./tmpConfigs/ss-redir.service
	else
		sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-redir.service
		sed -i "s/9001/${ssPort}/g" ./tmpConfigs/ss-redir.service
	fi
	
	if [ ${ssTcpFast}x = "Y"x ] || [ ${ssTcpFast}x = "y"x ]; then
		sed -i "s/isTcpFast/--fast-open/g" ./tmpConfigs/ss-redir.service
	fi

	echo "=================== after config ./tmpConfigs/ss-redir.service start ================="
	cat ./tmpConfigs/ss-redir.service
	echo "=================== after config ./tmpConfigs/ss-redir.service end ================="
}

service_chinadns_config()
{
	cp configs/chinaDns.service ./tmpConfigs/
	sed -i "s/1053/${sstListenPort}/g" ./tmpConfigs/chinaDns.service
	
	echo "=================== after config ./tmpConfigs/chinaDns.service start ================="
	cat ./tmpConfigs/chinaDns.service
	echo "=================== after config ./tmpConfigs/chinaDns.service end ================="
}

service_dnscrypt_proxy_config()
{
	cp configs/dnscrypt-proxy.service ./tmpConfigs/
	cp configs/dnscrypt-proxy.conf ./tmpConfigs/
}

service_sstunnel_config()
{
	cp configs/ss-tunnel-4.2.2.1.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-4.2.2.1.service
	sed -i "s/9001/${sstSrvPort1}/g" ./tmpConfigs/ss-tunnel-4.2.2.1.service
	sed -i "s/1053/${sstListenPortv1}/g" ./tmpConfigs/ss-tunnel-4.2.2.1.service

	cp configs/ss-tunnel-4.2.2.2.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-4.2.2.2.service
	sed -i "s/9001/${sstSrvPort2}/g" ./tmpConfigs/ss-tunnel-4.2.2.2.service
	sed -i "s/1053/${sstListenPortv2}/g" ./tmpConfigs/ss-tunnel-4.2.2.2.service

	cp configs/ss-tunnel-4.2.2.3.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-4.2.2.3.service
	sed -i "s/9001/${sstSrvPort3}/g" ./tmpConfigs/ss-tunnel-4.2.2.3.service
	sed -i "s/1053/${sstListenPortv3}/g" ./tmpConfigs/ss-tunnel-4.2.2.3.service

	cp configs/ss-tunnel-4.2.2.4.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-4.2.2.4.service
	sed -i "s/9001/${sstSrvPort4}/g" ./tmpConfigs/ss-tunnel-4.2.2.4.service
	sed -i "s/1053/${sstListenPortv4}/g" ./tmpConfigs/ss-tunnel-4.2.2.4.service

	cp configs/ss-tunnel-4.2.2.5.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-4.2.2.5.service
	sed -i "s/9001/${sstSrvPort5}/g" ./tmpConfigs/ss-tunnel-4.2.2.5.service
	sed -i "s/1053/${sstListenPortv5}/g" ./tmpConfigs/ss-tunnel-4.2.2.5.service

	cp configs/ss-tunnel-4.2.2.6.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-4.2.2.6.service
	sed -i "s/9001/${sstSrvPort6}/g" ./tmpConfigs/ss-tunnel-4.2.2.6.service
	sed -i "s/1053/${sstListenPortv6}/g" ./tmpConfigs/ss-tunnel-4.2.2.6.service

	cp configs/ss-tunnel-8.8.8.8.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-8.8.8.8.service
	sed -i "s/9001/${sstSrvPort7}/g" ./tmpConfigs/ss-tunnel-8.8.8.8.service
	sed -i "s/1053/${sstListenPortv7}/g" ./tmpConfigs/ss-tunnel-8.8.8.8.service

	cp configs/ss-tunnel-8.8.4.4.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-8.8.4.4.service
	sed -i "s/9001/${sstSrvPort8}/g" ./tmpConfigs/ss-tunnel-8.8.4.4.service
	sed -i "s/1053/${sstListenPortv8}/g" ./tmpConfigs/ss-tunnel-8.8.4.4.service
	
	cp configs/ss-tunnel-att-12.166.30.2.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-att-12.166.30.2.service
	sed -i "s/9001/${sstSrvPort9}/g" ./tmpConfigs/ss-tunnel-att-12.166.30.2.service
	sed -i "s/1053/${sstListenPortv9}/g" ./tmpConfigs/ss-tunnel-att-12.166.30.2.service

	cp configs/ss-tunnel-att-12.32.34.33.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-att-12.32.34.33.service
	sed -i "s/9001/${sstSrvPort1}/g" ./tmpConfigs/ss-tunnel-att-12.32.34.33.service
	sed -i "s/1053/${sstListenPortv10}/g" ./tmpConfigs/ss-tunnel-att-12.32.34.33.service

	cp configs/ss-tunnel-att-12.49.240.68.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-att-12.49.240.68.service
	sed -i "s/9001/${sstSrvPort2}/g" ./tmpConfigs/ss-tunnel-att-12.49.240.68.service
	sed -i "s/1053/${sstListenPortv11}/g" ./tmpConfigs/ss-tunnel-att-12.49.240.68.service

	cp configs/ss-tunnel-CA-192.5.5.241.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-CA-192.5.5.241.service
	sed -i "s/9001/${sstSrvPort3}/g" ./tmpConfigs/ss-tunnel-CA-192.5.5.241.service
	sed -i "s/1053/${sstListenPortv12}/g" ./tmpConfigs/ss-tunnel-CA-192.5.5.241.service

	cp configs/ss-tunnel-cogent-38.98.1.5.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-cogent-38.98.1.5.service
	sed -i "s/9001/${sstSrvPort4}/g" ./tmpConfigs/ss-tunnel-cogent-38.98.1.5.service
	sed -i "s/1053/${sstListenPortv13}/g" ./tmpConfigs/ss-tunnel-cogent-38.98.1.5.service

	cp configs/ss-tunnel-MLLZ-128.63.2.53.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-MLLZ-128.63.2.53.service
	sed -i "s/9001/${sstSrvPort5}/g" ./tmpConfigs/ss-tunnel-MLLZ-128.63.2.53.service
	sed -i "s/1053/${sstListenPortv14}/g" ./tmpConfigs/ss-tunnel-MLLZ-128.63.2.53.service

	cp configs/ss-tunnel-MS-65.54.238.70.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-MS-65.54.238.70.service
	sed -i "s/9001/${sstSrvPort6}/g" ./tmpConfigs/ss-tunnel-MS-65.54.238.70.service
	sed -i "s/1053/${sstListenPortv15}/g" ./tmpConfigs/ss-tunnel-MS-65.54.238.70.service

	cp configs/ss-tunnel-L3-209.244.0.3.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-L3-209.244.0.3.service
	sed -i "s/9001/${sstSrvPort7}/g" ./tmpConfigs/ss-tunnel-L3-209.244.0.3.service
	sed -i "s/1053/${sstListenPortv16}/g" ./tmpConfigs/ss-tunnel-L3-209.244.0.3.service

	cp configs/ss-tunnel-L3-209.244.0.4.service ./tmpConfigs/
	sed -i "s/127.0.0.1/${ssIP}/g" ./tmpConfigs/ss-tunnel-L3-209.244.0.4.service
	sed -i "s/9001/${sstSrvPort8}/g" ./tmpConfigs/ss-tunnel-L3-209.244.0.4.service
	sed -i "s/1053/${sstListenPortv17}/g" ./tmpConfigs/ss-tunnel-L3-209.244.0.4.service

	echo "=================== after config ./tmpConfigs/ss-tunnel.service start ================="
	cat ./tmpConfigs/ss-tunnel-8.8.8.8.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-8.8.4.4.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-4.2.2.1.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-4.2.2.2.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-4.2.2.3.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-4.2.2.4.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-4.2.2.5.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-4.2.2.6.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-att-12.166.30.2.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-att-12.32.34.33.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-att-12.49.240.68.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-CA-192.5.5.241.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-cogent-38.98.1.5.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-MLLZ-128.63.2.53.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-MS-65.54.238.70.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-L3-209.244.0.3.service
	echo "--------------------------------------------------------------------------------"
	cat ./tmpConfigs/ss-tunnel-L3-209.244.0.4.service
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
	service_sstunnel_config
	service_dnscrypt_proxy_config
	#service_chinadns_config
	if [ ${isConfigKCP}x = "Y"x ] || [ ${isConfigKCP}x = "y"x ]; then
		service_kcp_config
	fi
	service_ss_redir_config
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
		#echo "incorrect"
		exit 1
	fi

	sudo iptables -t nat -A POSTROUTING -o ${outInterface} -j MASQUERADE  
	sudo iptables -A FORWARD -i ${outInterface} -o ${apName} -m state --state RELATED,ESTABLISHED -j ACCEPT  
	sudo iptables -A FORWARD -i ${apName} -o ${outInterface} -j ACCEPT 


	if [ ${isConfigSS}x = "Y"x ] || [ ${isConfigSS}x = "y"x ]; then
		enableAP_ss_forward
	fi

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

	sudo cp ./tmpConfigs/dnscrypt-proxy.service /lib/systemd/system/
	sudo cp ./tmpConfigs/dnscrypt-proxy.conf /usr/local/etc/

	if [ ${isConfigSS}x = "Y"x ] || [ ${isConfigSS}x = "y"x ]; then
		sudo cp ./tmpConfigs/ss-tunnel-4.2.2.1.service /lib/systemd/system/
		sudo cp ./tmpConfigs/ss-tunnel-4.2.2.2.service /lib/systemd/system/
		sudo cp ./tmpConfigs/ss-tunnel-4.2.2.3.service /lib/systemd/system/
		sudo cp ./tmpConfigs/ss-tunnel-4.2.2.4.service /lib/systemd/system/
		sudo cp ./tmpConfigs/ss-tunnel-4.2.2.5.service /lib/systemd/system/
		sudo cp ./tmpConfigs/ss-tunnel-4.2.2.6.service /lib/systemd/system/

		sudo cp ./tmpConfigs/ss-tunnel-8.8.8.8.service /lib/systemd/system/
		sudo cp ./tmpConfigs/ss-tunnel-8.8.4.4.service /lib/systemd/system/

		sudo cp ./tmpConfigs/ss-tunnel-att-12.166.30.2.service /lib/systemd/system/
		sudo cp ./tmpConfigs/ss-tunnel-att-12.32.34.33.service /lib/systemd/system/
		sudo cp ./tmpConfigs/ss-tunnel-att-12.49.240.68.service /lib/systemd/system/
		sudo cp ./tmpConfigs/ss-tunnel-CA-192.5.5.241.service /lib/systemd/system/
		sudo cp ./tmpConfigs/ss-tunnel-cogent-38.98.1.5.service /lib/systemd/system/
		sudo cp ./tmpConfigs/ss-tunnel-MLLZ-128.63.2.53.service /lib/systemd/system/
		sudo cp ./tmpConfigs/ss-tunnel-MS-65.54.238.70.service /lib/systemd/system/
		sudo cp ./tmpConfigs/ss-tunnel-L3-209.244.0.3.service /lib/systemd/system/
		sudo cp ./tmpConfigs/ss-tunnel-L3-209.244.0.4.service /lib/systemd/system/
		#sudo cp ./tmpConfigs/chinaDns.service /lib/systemd/system/
		sudo cp ./tmpConfigs/ss-redir.service /lib/systemd/system/
		if [ ${isConfigKCP}x = "Y"x ] || [ ${isConfigKCP}x = "y"x ]; then
			sudo cp ./tmpConfigs/kcp-tunnel.service /lib/systemd/system/
		fi
	fi
}

enableAP_service()
{
	sudo systemctl daemon-reload	

	sudo systemctl enable AP.service

	sudo systemctl enable dnscrypt-proxy.service

	if [ ${isConfigSS}x = "Y"x ] || [ ${isConfigSS}x = "y"x ]; then
		sudo systemctl enable ss-tunnel-4.2.2.1.service
		sudo systemctl enable ss-tunnel-4.2.2.2.service
		sudo systemctl enable ss-tunnel-4.2.2.3.service
		sudo systemctl enable ss-tunnel-4.2.2.4.service
		sudo systemctl enable ss-tunnel-4.2.2.5.service
		sudo systemctl enable ss-tunnel-4.2.2.6.service

		sudo systemctl enable ss-tunnel-8.8.8.8.service
		sudo systemctl enable ss-tunnel-8.8.4.4.service

		sudo systemctl enable ss-tunnel-att-12.166.30.2.service
		sudo systemctl enable ss-tunnel-att-12.32.34.33.service
		sudo systemctl enable ss-tunnel-att-12.49.240.68.service
		sudo systemctl enable ss-tunnel-CA-192.5.5.241.service
		sudo systemctl enable ss-tunnel-cogent-38.98.1.5.service
		sudo systemctl enable ss-tunnel-MLLZ-128.63.2.53.service
		sudo systemctl enable ss-tunnel-MS-65.54.238.70.service
		sudo systemctl enable ss-tunnel-L3-209.244.0.3.service
		sudo systemctl enable ss-tunnel-L3-209.244.0.4.service
		#sudo systemctl enable chinaDns.service
		sudo systemctl enable ss-redir.service
		if [ ${isConfigKCP}x = "Y"x ] || [ ${isConfigKCP}x = "y"x ]; then
			sudo systemctl enable kcp-tunnel.service
		fi
	fi
}

disableAP_service()
{
	sudo systemctl disable AP.service

	sudo systemctl disable dnscrypt-proxy.service

	sudo systemctl disable ss-tunnel-4.2.2.1.service
	sudo systemctl disable ss-tunnel-4.2.2.2.service
	sudo systemctl disable ss-tunnel-4.2.2.3.service
	sudo systemctl disable ss-tunnel-4.2.2.4.service
	sudo systemctl disable ss-tunnel-4.2.2.5.service
	sudo systemctl disable ss-tunnel-4.2.2.6.service

	sudo systemctl disable ss-tunnel-8.8.8.8.service
	sudo systemctl disable ss-tunnel-8.8.4.4.service

	sudo systemctl disable ss-tunnel-att-12.166.30.2.service
	sudo systemctl disable ss-tunnel-att-12.32.34.33.service
	sudo systemctl disable ss-tunnel-att-12.49.240.68.service
	sudo systemctl disable ss-tunnel-CA-192.5.5.241.service
	sudo systemctl disable ss-tunnel-cogent-38.98.1.5.service
	sudo systemctl disable ss-tunnel-MLLZ-128.63.2.53.service
	sudo systemctl disable ss-tunnel-MS-65.54.238.70.service
	sudo systemctl disable ss-tunnel-L3-209.244.0.3.service
	sudo systemctl disable ss-tunnel-L3-209.244.0.4.service

	sudo systemctl disable chinaDns.service
	sudo systemctl disable ss-redir.service
	sudo systemctl disable kcp-tunnel.service

	sudo systemctl daemon-reload	
}

remove_all_configs()
{

	sudo rm -rf /etc/hostapd/hostapd.conf 
	sudo rm -rf /etc/dnsmasq_AP.conf 
	sudo rm -rf /lib/systemd/system/AP.service 

	sudo rm -rf /lib/systemd/system/dnscrypt-proxy.service 
	sudo rm -rf /usr/local/etc/dnscrypt-proxy.conf 

	sudo rm -rf /lib/systemd/system/ss-tunnel-4.2.2.1.service 
	sudo rm -rf /lib/systemd/system/ss-tunnel-4.2.2.2.service 
	sudo rm -rf /lib/systemd/system/ss-tunnel-4.2.2.3.service 
	sudo rm -rf /lib/systemd/system/ss-tunnel-4.2.2.4.service 
	sudo rm -rf /lib/systemd/system/ss-tunnel-4.2.2.5.service 
	sudo rm -rf /lib/systemd/system/ss-tunnel-4.2.2.6.service 

	sudo rm -rf /lib/systemd/system/ss-tunnel-8.8.8.8.service 
	sudo rm -rf /lib/systemd/system/ss-tunnel-8.8.4.4.service 

	sudo rm -rf /lib/systemd/system/ss-tunnel-att-12.166.30.2.service
	sudo rm -rf /lib/systemd/system/ss-tunnel-att-12.32.34.33.service
	sudo rm -rf /lib/systemd/system/ss-tunnel-att-12.49.240.68.service
	sudo rm -rf /lib/systemd/system/ss-tunnel-CA-192.5.5.241.service
	sudo rm -rf /lib/systemd/system/ss-tunnel-cogent-38.98.1.5.service
	sudo rm -rf /lib/systemd/system/ss-tunnel-MLLZ-128.63.2.53.service
	sudo rm -rf /lib/systemd/system/ss-tunnel-MS-65.54.238.70.service
	sudo rm -rf /lib/systemd/system/ss-tunnel-L3-209.244.0.3.service
	sudo rm -rf /lib/systemd/system/ss-tunnel-L3-209.244.0.4.service

	sudo rm -rf /lib/systemd/system/chinaDns.service 
	sudo rm -rf /lib/systemd/system/ss-redir.service 
	sudo rm -rf /lib/systemd/system/kcp-tunnel.service 

	sudo rm -rf /etc/iptables.ipv4.nat

	sed -i '/\[keyfile\]/d' ./tmpConfigs/NetworkManager.conf
	sed -i '/unmanaged-devices/d' ./tmpConfigs/NetworkManager.conf

	sed -i '/unmanaged-devices/d' /etc/NetworkManager/NetworkManager.conf
	sed -i '/iptables-restore < \/etc\/iptables.ipv4.nat/d' /etc/network/interfaces
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

install_dnscrypt_proxy()
{
	sudo apt-get install libltdl7-dev
	sudo apt-get install pkg-config libsystemd-dev

	mkdir -p /opt/github
	cd /opt/github
	git clone https://github.com/jedisct1/dnscrypt-proxy.git
	cd dnscrypt-proxy
	./autogen.sh
	./configure --with-systemd
	make
	sudo make install
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
		install_dnscrypt_proxy

		get_args

		unmanaged_devices
		hostapd_config
		dnsmasq_config
		encapsulate_service

		enableAP_forward_startup

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
	"reconfig") echo "Reconfig..."
		get_args

		unmanaged_devices
		hostapd_config
		dnsmasq_config
		encapsulate_service

		enableAP_forward_startup

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
		ps -ef | grep -E ".*hostapd|.*dnsmasq|.*dnscrypt-proxy|.*ss-tunnel|.*chinadns|.*ss-redir|.*client_linux_amd64" | grep -v grep
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
	"uninstall") echo "Uninstalling..."
		uninstall_all
	;;
	*) echo "unknow cmd"
esac

