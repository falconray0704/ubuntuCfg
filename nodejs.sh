#!/bin/bash

set -o nounset
set -o errexit

VERSION_NVM="v0.33.11"


tips_nrm_func()
{
    echo "List all npm source: "
    echo "npm install -g nrm"

}

install_nrm_func()
{
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm alias default v10.12.0

    npm install -g nrm
}

install_nodejs_func()
{
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    nvm install v4.9.1
    nvm install v6.14.4
    nvm install v8.12.0
    nvm install v10.12.0

    nvm alias default v10.12.0
}

install_nvm_func()
{
    curl -o- https://raw.githubusercontent.com/creationix/nvm/${VERSION_NVM}/install.sh | bash

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    nvm --version
}


case $1 in
    installNvm) echo "Installing nvm ${VERSION_NVM}..."
        install_nvm_func
        ;;
    installNodejs) echo "Installing nodejs..."
        install_nodejs_func
        ;;
    installNrm) echo "Installing nrm..."
        install_nrm_func
        ;;
    tipsNrm) echo "Tips nrm:"
        tips_nrm_func
        ;;
    *) echo "Unknown cmd: $1"
esac


