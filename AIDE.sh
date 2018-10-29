#!/bin/bash

set -o nounset
set -o errexit

AIDE_VERSION="0.16"
AIDE_HOME="/opt/github/aide"


install_from_repo_func()
{
    sudo apt-get install aide
    echo ""
    echo ""
    echo "Checking aide installation:"
    aide -v
    echo ""
}

uninstall_from_repo_func()
{
    sudo apt-get --purge remove aide
}

install_from_source_func()
{
    set -x
    sudo apt-get install libgcrypt*

    mkdir -p ${AIDE_HOME}

    pushd ${AIDE_HOME}

    rm -rf aide-${AIDE_VERSION}*
    wget -c https://pilotfiber.dl.sourceforge.net/project/aide/aide/${AIDE_VERSION}/aide-${AIDE_VERSION}.tar.gz
    tar -zxf aide-${AIDE_VERSION}.tar.gz


    pushd aide-${AIDE_VERSION}
    ./configure
    make
    sudo make install
    popd

    popd
    set +x

    echo ""
    echo ""
    echo "Checking aide installation:"
    aide -v
}

uninstall_from_source_func()
{
    set -x
    pushd ${AIDE_HOME}
    pushd aide-${AIDE_VERSION}
    sudo make uninstall
    make clean
    make distclean
    popd
    popd
    set +x
}


case $1 in
    installFromRepo) echo "Installing AIDE from Repo..."
        install_from_repo_func
        ;;
    uninstallFromRepo) echo "Uninstalling AIDE from Repo..."
        uninstall_from_repo_func
        ;;
    installFromSrc) echo "Installing AIDE from source..."
        install_from_source_func
        ;;
    uninstallFromSrc) echo "Uninstalling AIDE from source..."
        uninstall_from_source_func
        ;;
    *) echo "Unknown cmd: $1"
esac


