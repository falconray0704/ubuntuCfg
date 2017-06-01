#!/bin/bash


#sudo -H pip install keras
sudo -H pip install keras==1.2.2
sudo -H pip install opencv-python
sudo -H pip install imread
sudo -H pip install Pillow
sudo -H pip install h5py

install_cpu()
{
    sudo -H pip uninstall tensorflow
    bazel clean
    ./configure
    bazel build --config=opt --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" //tensorflow/tools/pip_package:build_pip_package
    bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
    sudo -H pip install /tmp/tensorflow_pkg/tensorflow-1.0.1-cp27-cp27mu-linux_x86_64.whl
}

install_gpu()
{
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
            install_gpu
	;;
	*) echo "unknow cmd"
esac


