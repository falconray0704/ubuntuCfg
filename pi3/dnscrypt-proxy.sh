#!/bin/bash

install_dependency_func()
{
    go get github.com/BurntSushi/toml
    go get github.com/VividCortex/ewma
    go get github.com/VividCortex/godaemon
    go get github.com/coreos/go-systemd/activation
    go get github.com/coreos/go-systemd/daemon
    go get github.com/dchest/safefile
    go get github.com/hashicorp/go-immutable-radix
    go get github.com/hashicorp/golang-lru
    go get github.com/jedisct1/dlog
    go get github.com/jedisct1/go-minisign
    go get github.com/jedisct1/xsecretbox
    go get github.com/kardianos/service
    go get github.com/miekg/dns
    go get github.com/pquerna/cachecontrol/cacheobject
}

install_dnscrypt_proxy_func()
{
    rm -rf dnscrypt-proxy
    git clone https://github.com/jedisct1/dnscrypt-proxy.git
    pushd /opt/github/dnscrypt-proxy/dnscrypt-proxy
    git pull

    go clean

    # Linux
    go build -ldflags="-s -w" -o dnscrypt-proxy

    mkdir -p ~/dnsCryptProxy
    cp ./dnscrypt-proxy ~/dnsCryptProxy/
    cp ./example-* ~/dnsCryptProxy/
    cp ../systemd/* ~/dnsCryptProxy/

    popd

    cp dnsCryptSrc/*.md ~/dnsCryptProxy/
}

disable_dnsmasq_func()
{
    sudo apt-get remove dnsmasq
    sudo apt-get purge dnsmasq

    sudo sed -i '/dns-nameservers/d' /etc/network/interfaces
    sudo sed -i '$a dns-nameservers 127.0.0.1' /etc/network/interfaces
	sudo sed -i 's/.*dns=dnsmasq.*/#dns=dnsmasq/' /etc/NetworkManager/NetworkManager.conf

}

config_dnscrypt_proxy_func()
{
    pushd ~/dnsCryptProxy
    cp example-dnscrypt-proxy.toml dnscrypt-proxy.toml
	sed -i "s/.*server_names =.*/server_names = \['cisco', 'cisco-ipv6'\]/" dnscrypt-proxy.toml

    sudo ./dnscrypt-proxy -service install

    popd
}


case $1 in
    "install_dependency") echo "Install dependency..."
        install_dependency_func
        echo "Install dependency finished."
    ;;
    "install_dnscrypt_proxy") echo "Install dnscrypt proxy..."
        install_dnscrypt_proxy_func
        echo "Install dnscrypt finished."
    ;;
    "disable_dnsmasq") echo "Disable dnsmasq as default dns..."
        disable_dnsmasq_func
        echo "Disable dnsmasq as default dns finished."
    ;;
    "config_dnscrypt_proxy") echo "Config dnscrypt proxy..."
        config_dnscrypt_proxy_func
        echo "Config dnscrypt finished."
    ;;
	*) echo "unknow cmd"
esac




