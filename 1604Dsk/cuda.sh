#!/bin/bash

install_cuda_Toolkit()
{
    sudo dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
    sudo apt-get update
    sudo apt-get install cuda

    echo "export the following environment to your PATH:"
    echo "export PATH=$PATH:/usr/local/cuda/bin"
}

install_cuda_cuDNN_5_1()
{
    cd /md/etmp/nvidia/cudnn_5.1
    tar -zxf cudnn-8.0-linux-x64-v5.1.tgz
    cp -a cuda/include/* /usr/local/cuda/include/
    cp -a cuda/lib64/* /usr/local/cuda/lib64/

}

cd /md/etmp/nvidia

install_cuda_Toolkit
install_cuda_cuDNN_5_1




