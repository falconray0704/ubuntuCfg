#!/bin/bash

set -o nounset
set -o errexit

install_DockerCompose_func()
{
    # refer to https://www.berthon.eu/2017/getting-docker-compose-on-raspberry-pi-arm-the-easy-way/
    local BuildRoot:="/opt/github/docker"
    mkdir -p ${BuildRoot}
    pushd ${BuildRoot}
    git clone https://github.com/docker/compose.git
    pushd compose
    git checkout release
    docker build -t docker-compose:armhf -f Dockerfile.armhf .
    docker run --rm --entrypoint="script/build/linux-entrypoint" -v $(pwd)/dist:/code/dist -v $(pwd)/.git:/code/.git "docker-compose:armhf"
    popd
    popd
}

install_Docker_func()
{
    # refer to https://www.raspberrypi.org/blog/docker-comes-to-raspberry-pi/
    curl -sSL https://get.docker.com | sh

    # use Docker as a non-root user
    sudo usermod -aG docker pi

    sudo reboot
}

check_Docker_Env_func()
{
    docker info
    docker version
    docker run -i -t resin/rpi-raspbian
}

case $1 in
    installDocker) echo "Installing ..."
        install_Docker_func
        ;;
    checkDocker) echo "Checking docker env..."
        check_Docker_Env_func
        ;;
    installDockerCompose) echo "Installing Docker Compose ..."
        install_DockerCompose_func
        ;;
    *) echo "Unknown cmd: $1"
esac


