#!/bin/bash

install_goenv()
{

	sudo apt-get -y update
	sudo apt-get -y install gccgo-5

	cd ~/
	rm -rf go go1.4

	wget -c https://storage.googleapis.com/golang/go1.4-bootstrap-20161024.tar.gz
	tar -zxf go1.4-bootstrap-20161024.tar.gz
	mv go go1.4
	cd ~/go1.4/src
	sudo update-alternatives --set go /usr/bin/go-5
	GOROOT_BOOTSTRAP=/usr ./make.bash
	cd ~

	wget -c https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz
	tar -zxf go1.8.linux-amd64.tar.gz

	mkdir -p /opt/gows

	# set go env
	#vim ~/.bashrc
	echo '# go env' >> ~/.bashrc
	echo 'export GOROOT=$HOME/go' >> ~/.bashrc
	echo 'export GOPATH=/opt/gows' >> ~/.bashrc
	echo 'export PATH=$PATH:$GOROOT/bin' >> ~/.bashrc

}

build_latest_kcp()
{
	mkdir -p /opt/gows/src/github.com/xtaci/
	cd /opt/gows/src/github.com/xtaci/
	rm -rf kcptun

	go get github.com/golang/snappy
	go get github.com/xtaci/kcp-go
	go get github.com/urfave/cli
	go get github.com/xtaci/smux
	go get golang.org/x/crypto/pbkdf2
	go get github.com/pkg/errors

	go get github.com/xtaci/kcptun

	cd /opt/gows/src/github.com/xtaci/kcptun

	./build-release.sh
}


case $1 in
	"build_latest_kcp") echo "building latest..."
		echo "Kcp construction depend on Go env. "
		echo "Do you want to build up Go environment before continue? [y/N]:"
		read isContinue
		if [ ${isContinue}x = "y"x ] || [ ${isContinue}x = "Y"x ]; then
			install_goenv
			export GOROOT=$HOME/go
			export GOPATH=/opt/gows
			export PATH=$PATH:$GOROOT/bin
			which go
		else
			echo "Do not build Go env"
		fi
		
		#echo "Going to build kcp,press any key to continue."
		#read isContinue
		build_latest_kcp
		sudo cp /opt/gows/src/github.com/xtaci/kcptun/*_linux_amd64 /usr/local/bin/
	;;
	*) echo "unknow cmd"
esac
