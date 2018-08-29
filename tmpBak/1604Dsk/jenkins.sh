#!/bin/bash

install_jenkins()
{
    sudo apt-get install gcovr
    sudo apt-get install scons

    sudo mkdir -p /opt/prog/jenkins
    sudo chown -hR ray /opt/prog/jenkins
    sudo chgrp -R ray /opt/prog/jenkins
    cd /opt/prog/jenkins
    wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war

    java -jar ./jenkins.war
}

start_jenkins()
{
    cd /opt/prog/jenkins
    java -jar ./jenkins.war &
}

stop_jenkins()
{
	jenkinsClients=`ps -ef | grep jenkins.war | grep "\-jar" | awk '{print $2}'`
	for pid in ${jenkinsClients}
	do
		#echo ${pid}
		kill -9 ${pid}
	done
}



case $1 in
	"install") echo "Installing..."
            install_jenkins
	;;
	"uninstall") echo "Uninstall..."
            exit 0
	;;
	"start") echo "starting..."
            start_jenkins
	;;
	"restart") echo "restarting..."
            stop_jenkins
            start_jenkins
	;;
	"stop") echo "stop..."
            stop_jenkins
	;;
	"test") echo "testing..."
            echo "test cmd."
	;;
	*) echo "unknow cmd"
esac


#uninstall_nfs_git_data_dir ${nfs_git_data_path}


