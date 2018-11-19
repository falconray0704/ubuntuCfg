#!/bin/bash

set -o nounset
set -o errexit

AIDE_VERSION="0.16"
AIDE_HOME="/opt/github/aide"
AIDE_INSTALL_PREFIX="/usr/local"


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
    ./configure --prefix=${AIDE_INSTALL_PREFIX}
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


case $1 in
    installFromRepo) echo "Installing AIDE from Repo..."
        #install_from_repo_func
        echo "Do not clear what problem result in the running error, do not use this approach for deployment by now."
        ;;
    uninstallFromRepo) echo "Uninstalling AIDE from Repo..."
        #uninstall_from_repo_func
        echo "Do not clear what problem result in the running error, do not use this approach for deployment by now."
        ;;
    installFromSrc) echo "Installing AIDE from source..."
        install_from_source_func
        ;;
    uninstallFromSrc) echo "Uninstalling AIDE from source..."
        uninstall_from_source_func
        ;;
    tips) echo "Using tips:"
        tips_func
        ;;
    *) echo "Unknown cmd: $1"
esac


