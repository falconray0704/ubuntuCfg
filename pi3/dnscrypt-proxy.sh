#!/bin/bash

install_dependency()
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

install_dnscrypt_proxy()
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

config_dnscrypt_proxy()
{
    sudo apt-get remove dnsmasq
    sudo apt-get purge dnsmasq
}

install_dependency
install_dnscrypt_proxy
config_dnscrypt_proxy





