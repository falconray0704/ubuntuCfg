#!/bin/bash

set -o nounset
set -o errexit

RootDir="/opt/github/mySQLs"
VersionMySQL="5.7.23"

build_mysql_func()
{
    build_mysql_version_func ${VersionMySQL}
}

build_mysql_version_func()
{
    local Version=$1

    pushd ${RootDir}

    pushd build/mysql-${Version}
    make package
    popd

    popd
}

config_mysql_func()
{
    config_mysql_version_func ${VersionMySQL}
}

config_mysql_version_func()
{
    local Version=$1
    pushd ${RootDir}

    pushd src
    tar -zxf mysql-${Version}.tar.gz
    popd

    rm -rf build/mysql-${Version}
    mkdir -p build/mysql-${Version}
    pushd build/mysql-${Version}
    cmake ../../src/mysql-${Version} -DCPACK_MONOLITHIC_INSTALL=1 -DCMAKE_INSTALL_PREFIX=${RootDir}/rel/mysql-${Version} -DBUILD_CONFIG=mysql_release -DWITH_BOOST=/opt/github/boostorg/boost_1_59_0 -DWITH_INNODB_MEMCACHED=1
    popd

    popd
}

fetch_mysql_func()
{
    local Version=${VersionMySQL}
    fetch_mysql_version_func ${Version}
}

fetch_mysql_version_func()
{
    local Version=$1
    pushd ${RootDir}

    pushd src
    wget -c https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-${Version}.tar.gz
    popd

    popd
}

init_operation_dirs_func()
{
    mkdir -p ${RootDir}
    pushd ${RootDir}
    mkdir -p src rel build
    popd
}

init_operation_dirs_func

case $1 in
    fetch) echo "Fetching mySQL ${VersionMySQL} ..."
        fetch_mysql_func
        ;;
    config) echo "Configuring mySQL ..."
        config_mysql_func
        ;;
    build) echo "Build mySQL ..."
        build_mysql_func
        ;;
    *|-h) echo "Unknow command, supported commands:"
        echo "fetch"
        ;;
esac


