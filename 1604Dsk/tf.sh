#!/bin/bash


install_dependence()
{
    echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
    curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
    sudo apt-get update && sudo apt-get install bazel
    sudo apt-get upgrade bazel

    sudo apt-get install python-numpy python-dev python-pip python-wheel
    sudo apt-get install python3-numpy python3-dev python3-pip python3-wheel

    sudo -H pip install six numpy wheel
    sudo -H pip install --upgrade pip

    mkdir -p /md/github
    cd /md/github
    git clone https://github.com/tensorflow/tensorflow
    cd tensorflow
    git checkout r1.0
}

install_cpu()
{
    install_dependence

    sudo -H pip uninstall tensorflow
    bazel clean
    ./configure
    bazel build --config=opt --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" //tensorflow/tools/pip_package:build_pip_package
    bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
    sudo -H pip install /tmp/tensorflow_pkg/tensorflow-1.0.1-cp27-cp27mu-linux_x86_64.whl
}

install_gpu()
{
    install_dependence

    sudo apt-get install libcupti-dev
    sudo -H pip uninstall tensorflow
    bazel clean
    ./configure
    bazel build --config=opt --config=cuda --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" //tensorflow/tools/pip_package:build_pip_package
    bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
    sudo -H pip install /tmp/tensorflow_pkg/tensorflow-1.0.1-cp27-cp27mu-linux_x86_64.whl
}

case $1 in
	"install_cpu") echo "Installing cpu version tensorflow ..."
            install_cpu
	;;
	"install_gpu") echo "Installing GPU version tensorflow ..."
        echo "Before continue you have to activate python env. "
        echo "Have you enabled it? [y/N]:"
        read isContinue
        if [ ${isContinue}x = "y"x ] || [ ${isContinue}x = "Y"x ]
        then
            install_gpu
        else
            exit 1
        fi
	;;
	*) echo "unknow cmd"
esac


