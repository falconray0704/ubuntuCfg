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

    sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler
    sudo apt-get install --no-install-recommends libboost-all-dev

    sudo apt-get install libatlas-base-dev libopenblas-dev


    sudo apt-get install libgflags-dev
    sudo apt-get install libgflags-dev libgoogle-glog-dev liblmdb-dev


}

install_weiliu89_ssd_func()
{
    install_dependence

    mkdir -p /md/proj/github/weiliu89
    cd /md/proj/github/weiliu89

    git clone https://github.com/weiliu89/caffe.git
    cd caffe
    git checkout ssd


    # Modify Makefile.config according to your Caffe installation.
    cp Makefile.config.example Makefile.config

    echo "Modify Makefile.config according to your Caffe installation."
    echo "Then run build instruction."

}

build_func()
{
    cd /md/proj/github/weiliu89

    make -j8
    # Make sure to include $CAFFE_ROOT/python to your PYTHONPATH.
    make py
    make test -j8
    # (Optional)
    make runtest -j8
}

case $1 in
	"install_weiliu89_ssd") echo "Installing weiliu89 ssd..."
            install_weiliu89_ssd_func
	;;
	"build") echo "Build weiliu89 ssd..."
            build_func
	;;
	*) echo "unknow cmd"
esac


