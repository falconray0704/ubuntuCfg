#!/bin/bash

set -o nounset
set -o errexit

SAMHAIN_VERSION="4.3.1"
SAMHAIN_HOME="/opt/github/samhain"

install_from_source_func()
{
    set -x

    mkdir -p ${SAMHAIN_HOME}

    pushd ${SAMHAIN_HOME}

    rm -rf s_rkey.html
    rm -rf samhain-${SAMHAIN_VERSION}*
    rm -rf samhain-current.tar.gz

    echo "Downloading source code..."
    wget -c https://www.la-samhna.de/samhain/samhain-current.tar.gz
    tar -zxf samhain-current.tar.gz

    echo "Get the samhain development PGP key 1024D/0F571F6C"
    #gpg --keyserver pks.gpg.cz --recv-key 0F571F6C
    wget -c https://www.la-samhna.de/samhain/s_rkey.html
    gpg --import s_rkey.html
    echo "Check the key fingerprint (EF6C EF54 701A 0AFD B86A F4C3 1AAD 26C8 0F57 1F6C)"
    gpg --fingerprint 0F571F6C
    echo "Verify the PGP signature on the distribution tarball"
    gpg --verify samhain-${SAMHAIN_VERSION}.tar.gz.asc samhain-${SAMHAIN_VERSION}.tar.gz

    tar -zxf samhain-${SAMHAIN_VERSION}.tar.gz
    cd samhain-${SAMHAIN_VERSION}
    ./configure
    make

    popd
    set +x

    echo ""
    echo ""
    echo "Checking aide installation:"
}

uninstall_from_source_func()
{
    set -x
    pushd ${SAMHAIN_HOME}
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
    installFromSrc) echo "Installing Samhain from source..."
        install_from_source_func
        ;;
    tips) echo "Using tips:"
        tips_func
        ;;
    *) echo "Unknown cmd: $1"
esac


