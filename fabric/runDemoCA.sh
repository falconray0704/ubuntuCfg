#!/bin/bash

set -o nounset
set -o errexit

#RUN_ROOT="${PWD}/runEnv"
RUN_ROOT="${HOME}/runEnv"
# If you change this, you should change ./demoDockerCfgs/serverCA/docker-compose.yml 
# for docker running mode as well.
export FABRIC_CA_HOME="${RUN_ROOT}/fabric-ca-server"

tips_func()
{
    echo ""
    echo ""

}

enrollPeers_func()
{
    mkdir -p ${RUN_ROOT}/demoDockerCfgs/serverCA

    pushd ${RUN_ROOT}/demoDockerCfgs/serverCA
    docker-compose -f docker-compose-enrollPeers.yml up
    docker-compose -f docker-compose-enrollPeers.yml down
    popd

}

initEnrollPeers_func()
{
    mkdir -p ${RUN_ROOT}/demoDockerCfgs/serverCA
    cp -a demoDockerCfgs/serverCA/docker-compose-enrollPeers.yml ${RUN_ROOT}/demoDockerCfgs/serverCA/
    cp -a demoDockerCfgs/serverCA/enrollPeers.sh ${RUN_ROOT}/demoDockerCfgs/serverCA/

    echo "Config ${RUN_ROOT}/demoDockerCfgs/serverCA/enrollPeers.sh, and then run:"
    echo "./runDemoCA.sh enrollPeers"
}

registerPeers_func()
{
    mkdir -p ${RUN_ROOT}/demoDockerCfgs/serverCA

    pushd ${RUN_ROOT}/demoDockerCfgs/serverCA
    docker-compose -f docker-compose-registerPeers.yml up
    docker-compose -f docker-compose-registerPeers.yml down
    popd

}

initRegisterPeers_func()
{
    mkdir -p ${RUN_ROOT}/demoDockerCfgs/serverCA
    cp -a demoDockerCfgs/serverCA/docker-compose-registerPeers.yml ${RUN_ROOT}/demoDockerCfgs/serverCA/
    cp -a demoDockerCfgs/serverCA/registerPeers.sh ${RUN_ROOT}/demoDockerCfgs/serverCA/

    echo "Config ${RUN_ROOT}/demoDockerCfgs/serverCA/registerPeers.sh, and then run:"
    echo "./runDemoCA.sh registerPeers"
}

enrollBootstrapID_func()
{
    mkdir -p ${RUN_ROOT}/demoDockerCfgs/serverCA
    cp -a demoDockerCfgs/serverCA/docker-compose-enroll-bootstrap.yml ${RUN_ROOT}/demoDockerCfgs/serverCA/


    pushd ${RUN_ROOT}/demoDockerCfgs/serverCA
    docker-compose -f docker-compose-enroll-bootstrap.yml up
    docker-compose -f docker-compose-enroll-bootstrap.yml down
    popd

}

startFabricCA_Docker_func()
{
    pushd ${RUN_ROOT}/demoDockerCfgs/serverCA
    docker-compose up
    docker-compose down
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

    mkdir -p ${RUN_ROOT}/demoDockerCfgs/serverCA
    cp -a demoDockerCfgs/serverCA/docker-compose-init.yml ${RUN_ROOT}/demoDockerCfgs/serverCA
    cp -a demoDockerCfgs/serverCA/docker-compose.yml ${RUN_ROOT}/demoDockerCfgs/serverCA

    pushd ${RUN_ROOT}/demoDockerCfgs/serverCA
    docker-compose -f docker-compose-init.yml up
    docker-compose -f docker-compose-init.yml down
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
    enrollBootstrapID) echo "Enrolling the bootstrap identity..."
        enrollBootstrapID_func
        ;;
    initRegisterPeers) echo "Initializing peers register configuration files..."
        initRegisterPeers_func
        ;;
    registerPeers) echo "Registering peers ..."
        registerPeers_func
        ;;
    initEnrollPeers) echo "Initializing peers enrollment configuration files..."
        initEnrollPeers_func
        ;;
    enrollPeers) echo "Enrolling peers ..."
        enrollPeers_func
        ;;
    tips) echo "Using tips:"
        tips_func
        ;;
    *) echo "Unknown cmd: $1"
esac


