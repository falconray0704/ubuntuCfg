#!/bin/bash

set -o nounset
set -o errexit

RUN_ROOT="${PWD}/runEnv"
# If you change this, you should change ./demoDockerCfgs/serverCA/docker-compose.yml 
# for docker running mode as well.
export FABRIC_CA_HOME="${RUN_ROOT}/fabric-ca-server"


SAMHAIN_VERSION="4.3.1"
SAMHAIN_HOME="/opt/github/samhain"


tips_func()
{
    echo ""
    echo ""
    echo "User gudie for deployment:"
    echo "http://aide.sourceforge.net/stable/manual.html"
    echo ""
    echo ""
    echo "1) Checking aide version:"
    echo "sudo aide -v"

    echo "2) Init database:"
    echo "sudo aide --init"
    echo "sudo mv /path/to/aide.db.new /path/to/aide.db"

    echo "3) Check with database:"
    echo "sudo aide --check"

    echo "4) Update database"
    echo "sudo aide --update"
    echo "sudo mv /path/to/aide.db.new /path/to/aide.db"

}

startFabricCA_Docker_func()
{
    pushd demoDockerCfgs/serverCA
    ln -s ${RUN_ROOT} ./runEnv
    docker-compose up
    docker-compose down
    rm runEnv
    popd
}

startFabricCA_Native_func()
{
    export PATH=${PATH}:${GOPATH}/bin
    fabric-ca-server start -b admin:adminpw
}

initFabricCA_Docker_func()
{
    sudo rm -rf ${FABRIC_CA_HOME}

    mkdir -p ${FABRIC_CA_HOME}

    pushd demoDockerCfgs/serverCA
    ln -s ${RUN_ROOT} ./runEnv
    docker-compose -f docker-compose-init.yml up
    docker-compose -f docker-compose-init.yml down
    rm runEnv
    popd

    tree ${FABRIC_CA_HOME}

}

initFabricCA_Native_func()
{
    rm -rf ${FABRIC_CA_HOME}

    export PATH=${PATH}:${GOPATH}/bin
    initFabricCA_func
}

initFabricCA_func()
{
    mkdir -p ${FABRIC_CA_HOME}
    fabric-ca-server init -b admin:adminpw

    tree ${FABRIC_CA_HOME}
}

deployFabricCA_Docker_func()
{
    pushd demoDockerCfgs/serverCA
    docker-compose pull
    popd
}

deployFabricCA_Native_func()
{
    go get -u github.com/hyperledger/fabric-ca/cmd/...
    export PATH=${PATH}:${GOPATH}/bin

    fabric-ca-client version
    fabric-ca-server version
}

case $1 in
    deployNative) echo "Deploying FabricCA server natively..."
        deployFabricCA_Native_func
        ;;
    deployDocker) echo "Deploying FabricCA server with docker..."
        deployFabricCA_Docker_func
        ;;
    initNative) echo "Initializing FabricCA server natively..."
        initFabricCA_Native_func
        ;;
    initDocker) echo "Initializing FabricCA server with docker..."
        initFabricCA_Docker_func
        ;;
    startNative) echo "Launching FabricCA server natively..."
        startFabricCA_Native_func
        ;;
    startDocker) echo "Launching FabricCA server with docker..."
        startFabricCA_Docker_func
        ;;
    tips) echo "Using tips:"
        tips_func
        ;;
    *) echo "Unknown cmd: $1"
esac


