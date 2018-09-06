#!/bin/bash
set -o nounset
set -o errexit
# trace each command execute, same as `bash -v myscripts.sh`
#set -o verbose
# trace each command execute with attachment infomations, same as `bash -x myscripts.sh`
#set -o xtrace

install_numactl_func()
{
    local Version="2.0.12"

    pushd /opt/github

    mkdir -p numactl
    pushd numactl
    wget -O numactl-${Version}.tar.gz https://codeload.github.com/numactl/numactl/tar.gz/v${Version}
    rm -rf numactl-${Version}
    tar -zxf numactl-${Version}.tar.gz

    pushd numactl-${Version}
    ./autogen.sh
    ./configure
    make
    sudo make install
    popd

    popd

    popd
}

install_Latest_grpc()
{
    #sudo apt-get -y install build-essential autoconf libtool pkg-config
    #sudo apt-get -y install libgflags-dev libgtest-dev
    #sudo apt-get -y install clang libc++-dev

    pushd /opt/github
    #git clone https://github.com/grpc/grpc
    git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc
    pushd grpc
    git submodule update --init
    make
    sudo make install

    # install protobuf
    pushd third_party/protobuf
    sudo make install
    popd

    popd
    popd
}

deploy_boost_1_59_0_without_install_func()
{
    local Version="1.59.0"
    local VersionFile="1_59_0"
    fetch_boost_src_func ${Version} ${VersionFile}
    build_boost_version_without_install_func ${Version} ${VersionFile}
}

build_boost_1_59_0_without_install_func()
{
    local Version="1.59.0"
    local VersionFile="1_59_0"
    build_boost_version_without_install_func ${Version} ${VersionFile}
}

install_boost_src_1_59_0_func()
{
    local Version="1.59.0"
    local VersionFile="1_59_0"

    install_boost_version_func ${Version} ${VersionFile}
}

install_boost_version_func()
{
    local Version=$1
    local VersionFile=$2
    local RootDir=/opt/github/boostorg
    #local RootDir=/opt/etmp/boostorg
    pushd ${RootDir}

    pushd boost_${VersionFile}
    sudo mkdir -p /usr/local/boost_${VersionFile}
	sudo ./b2 --prefix=/usr/local/boost_${VersionFile} --with=all install

    #sudo sh -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/local.conf'
    #sudo ldconfig
    popd

    popd
}

fetch_boost_src_1_59_0_func()
{
    local Version="1.59.0"
    local VersionFile="1_59_0"
    fetch_boost_src_func ${Version} ${VersionFile}
}

build_boost_version_without_install_func()
{
    local Version=$1
    local VersionFile=$2
    local RootDir=/opt/github/boostorg
    #local RootDir=/opt/etmp/boostorg
    pushd ${RootDir}

    pushd boost_${VersionFile}
    ./bootstrap.sh --prefix=/usr/local/boost_${VersionFile}
	#user_configFile=`find $PWD -name user-config.jam`
	#echo "using mpi ;" >> $user_configFile
	#local nCPU=$(nproc --all) # limit for low memory system
	local nCPU=1
	echo "nCPU:${nCPU}"
	./b2 --prefix=/usr/local/boost_${VersionFile} --with=all -j${nCPU}
    popd

    popd
}

fetch_boost_src_func()
{
    local Version=$1
    local VersionFile=$2
    local RootDir=/opt/github/boostorg
    #local RootDir=/opt/etmp/boostorg
    mkdir -p ${RootDir}
    pushd ${RootDir}

    wget -O boost_${VersionFile}.tar.gz http://sourceforge.net/projects/boost/files/boost/${Version}/boost_${VersionFile}.tar.gz/download

    tar -zxf boost_${VersionFile}.tar.gz
	popd
}

deploy_general_repo_pkgs()
{
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    sudo apt-get -y install git wget curl tree htop
    sudo apt-get -y install automake autogen autoconf cmake zlib1g-dev gettext asciidoc pkg-config clang xmlto libev-dev libc-ares-dev
    sudo apt-get -y install build-essential g++ python-dev python-bzutils autotools-dev mecab mecab-ipadic
    sudo apt-get -y install libicu-dev libboost-all-dev libncurses5-dev libaio-dev libicu-dev libbz2-dev libssl-dev libpcre3 libpcre3-dev libtool libgflags-dev libgtest-dev libc++-dev

    #sudo apt-get -y install openssh-server

}

init_operation_dirs_func()
{
    mkdir -p /opt/github
	mkdir -p /opt/github/falcon
    mkdir -p /opt/etmp
}

init_operation_dirs_func

case $1 in
    "deployGenRepoPkgs") echo "Deploy general repo pkgs ..."
        deploy_general_repo_pkgs
        ;;
    "install_libnuma") echo "Install libnuma ..."
        install_numactl_func
        ;;
    "grpc") echo "Deploy grpc ..."
        deploy_general_repo_pkgs
        install_Latest_grpc
        ;;
    "fetchBoost") echo "Fetching boost 1.59.0 ..."
		fetch_boost_src_1_59_0_func
        ;;
    "buildBoost") echo "Building boost 1.59.0 ..."
        deploy_general_repo_pkgs
		build_boost_1_59_0_without_install_func
        ;;
    "installBoost") echo "Installing boost 1.59.0 ..."
        install_boost_src_1_59_0_func
        ;;
    "deployBoost") echo "Deploying boost 1.59.0 ..."
        deploy_general_repo_pkgs
		deploy_boost_1_59_0_without_install_func
        ;;
    "all") echo "Deploy all general packets ..."
        deploy_general_repo_pkgs
        install_Latest_grpc
		deploy_boost_1_59_0_without_install_func
        ;;
    *|-h) echo "Unknow command, supported commands:"
        echo "deployGenRepoPkgs"
        echo "install_libnuma"
        echo "grpc"
        echo "fetchBoost"
		echo "buildBoost"
        echo "installBoost"
		echo "deployBoost"
        echo "all"
        ;;
esac













