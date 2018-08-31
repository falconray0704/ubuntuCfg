#!/bin/bash

set -o nounset
set -o errexit
# trace each command execute, same as `bash -v myscripts.sh`
#set -o verbose
# trace each command execute with attachment infomations, same as `bash -x myscripts.sh`
#set -o xtrace


case $1 in
    apt) echo "apt using tips ..."

        echo "1) Check and install repo available packets:"
        echo "sudo apt-cache search libboost"
        echo "sudo apt-get install libboost1.62-*"

        echo "2) Remove repo packets:"
        echo "sudo apt autoremove vim"

        ;;
    *) echo "Without any tips about: $1"
        echo "--- Available tips: ---"
        echo "apt"
        echo "--- Available tips end ---"
        ;;
esac



