#!/bin/bash

#export http_proxy=192.168.1.100:6808
#export https_proxy=192.168.1.100:6808
#export sock5_proxy=192.168.1.100:1080

# asiapool.electroneum.com
# pool.etn.spacepools.org
# us-etn-pool.hashparty.io

#ccmd -a cryptonight -u etn -p x --proxy=socks5://192.168.1.100:2080 -o stratum+tcp://pool.etn.spacepools.org:7777 -t 1 -d 3

#./cpuminer -a cryptonight -u etn -p x --proxy=socks5://192.168.1.100:2080 -o stratum+tcp://us-etn-pool.hashparty.io:3333 -t 4

#./cpuminer -a cryptonight -u etn -p x --proxy=socks5://192.168.1.100:2080 -o stratum+tcp://pool.etn.spacepools.org:3333 -t 4

#./cpuminer -a cryptonight -u etn -p x -o stratum+tcp://pool.etn.spacepools.org:3333 -t 4


stop()
{
    workers=`ps -ef | grep ccaffe | grep -v 'grep\|run' | awk '{print $2}'`
    for pid in ${workers}
    do
        echo ${pid}
        kill -9 ${pid}
    done
}

start()
{
    ./ccaffe -a cryptonight -u etn -p x -o stratum+tcp://pool.etn.spacepools.org:7777 > logs.txt 2>&1 &
}

case $1 in
    "start") echo "running ..."
            start
    ;;
    "stop") echo "stoping ..."
            stop
    ;;
esac





