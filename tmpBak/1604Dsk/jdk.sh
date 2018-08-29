#!/bin/bash

#[install JDK]
#rm -rf /opt/prog/jdks
mkdir -p /opt/prog/jdks

install_jdk()
{
    # cp jdk-8u121-linux-x64.tar.gz to /opt/prog/jdks
    #cd /opt/prog/jdks
    eval `tar -zxf /opt/prog/jdks/jdk-8u121-linux-x64.tar.gz -C /opt/prog/jdks/`

    echo "export following env to ~/.bashrc :"
    #vim ~/.bashrc
    echo "export JAVA_HOME=/opt/prog/jdks/jdk1.8.0_121"
    echo "export JRE_HOME=/opt/prog/jdks/jdk1.8.0_121/jre"
    echo 'export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH'
}

echo "Copy jdk-8u121-linux-x64.tar.gz to /opt/prog/jdks before continue. Have you done? [y/N]:"
read isDone
if [ ${isDone}x = "y"x ] || [ ${isDone}x = "Y"x ]
then
    install_jdk
fi

