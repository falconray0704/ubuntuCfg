#!/bin/bash




config_proxy()
{
    echo "Please input http proxy IP:"
    read srvIP
    echo "Please input http proxy Port:"
    read srvPort

    echo "Your Docker proxy config as following description:"

    echo '[Service]' 
    echo "Environment=\"HTTP_PROXY=http://${srvIP}:${srvPort}/\""
    
    echo "Is it correct? [y/N]"
    read isCorrect

    if [ ${isCorrect}x = "Y"x ] || [ ${isCorrect}x = "y"x ]
    then
        sudo mkdir -p /etc/systemd/system/docker.service.d
        sudo chmod a+w /etc/systemd/system/docker.service.d

        #sudo vim mkdir -p /etc/systemd/system/docker.service.d/http-proxy.conf
        #append following lines
        #[Service]
        #Environment="HTTP_PROXY=http://proxy.example.com:80/"

        sudo echo '[Service]' > /etc/systemd/system/docker.service.d/http-proxy.conf
        sudo echo "Environment=\"HTTP_PROXY=http://${srvIP}:${srvPort}/\"" >> /etc/systemd/system/docker.service.d/http-proxy.conf
        cat /etc/systemd/system/docker.service.d/http-proxy.conf

        sudo systemctl daemon-reload
        sudo systemctl show --property=Environment docker
        sudo systemctl restart docker
    fi
}

install_docker()
{
    sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    sudo apt-get update
    sudo apt-get install docker-ce
}

reconfig_docker_proxy()
{
    echo "Do you want to config http proxy for docker? [y/N]:"
    read isConfigProxy
    if [ ${isConfigProxy}x = "y"x ] || [ ${isConfigProxy}x = "Y"x ]
    then
        config_proxy
    fi
    sudo docker run hello-world
}

case $1 in
	"install") echo "Installing..."
            install_docker
            reconfig_docker_proxy
	;;
	"reconfig_proxy") echo "Reconfig docker proxy..."
            reconfig_docker_proxy
	;;
	"test") echo "testing..."
            sudo docker run hello-world
	;;
	*) echo "unknow cmd"
esac





