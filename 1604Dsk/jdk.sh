#!/bin/bash

#[install JDK]
rm -rf /opt/prog/jdks
mkdir -p /opt/prog/jdks
tar -zxf /mnt/hgfs/etmp/jdk-8u121-linux-x64.tar.gz -C /opt/prog/jdks/
#vim ~/.bashrc
#export JAVA_HOME=/opt/prog/jdks/jdk1.8.0_121
#export JRE_HOME=/opt/prog/jdks/jdk1.8.0_121/jre
#export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH

