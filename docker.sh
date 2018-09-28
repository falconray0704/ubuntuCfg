#!/bin/bash

set -o nounset
set -o errexit

install_DockerCompose_func()
{
    # refer to https://docs.docker.com/compose/install/#install-compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    # https://docs.docker.com/compose/completion/#install-command-completion
    sudo curl -L https://raw.githubusercontent.com/docker/compose/1.22.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

    # check
    docker-compose --version

}

install_Docker_func()
{
    # https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce-1
    sudo apt-get update
    sudo apt-get install docker-ce
    sudo docker run hello-world

    # use Docker as a non-root user
    echo "User:$USER"
    sudo usermod -aG docker $USER

    #sudo reboot
}

check_Docker_Env_func()
{
    docker info
    docker version

    sudo docker run hello-world
}

uninstall_old_versions_func()
{
    sudo apt-get remove docker docker-engine docker.io
}

install_repo_func()
{
    sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    echo "Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88"
    sudo apt-key fingerprint 0EBFCD88

    #sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
}


case $1 in
    uninstallOldVersions) echo "Unstalling old versions..."
        uninstall_old_versions_func
        ;;
    installRepo) echo "Installing Repo for docker installation..."
        install_repo_func
        ;;
    installDocker) echo "Installing Docker-ce ..."
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


