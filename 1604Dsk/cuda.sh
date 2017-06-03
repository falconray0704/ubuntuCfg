#!/bin/bash

install_cuda_Toolkit_func()
{
    sudo dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
    sudo apt-get update
    sudo apt-get install cuda

}

install_cuda_cuDNN_5_1_func()
{
    cd /md/etmp/nvidia/cudnn_5.1
    tar -zxf cudnn-8.0-linux-x64-v5.1.tgz
    sudo cp -a cuda/include/* /usr/local/cuda/include/
    sudo cp -a cuda/lib64/* /usr/local/cuda/lib64/

}

install_cuda_Video_Codec_SDK_func()
{
    mkdir -p /md/nvidia
    cd /md/nvidia
    rm -rf Video_Codec_SDK_8.0.14
    cp /md/etmp/nvidia/Video_Codec_SDK_8.0.14.zip ./
    unzip Video_Codec_SDK_8.0.14.zip

    ls -al Video_Codec_SDK_8.0.14
    read isContinue
    sudo cp -r Video_Codec_SDK_8.0.14/Samples/common/inc/* /usr/include/
}

cd /md/etmp/nvidia

case $1 in
	"install") echo "Installing all..."
            install_cuda_Toolkit_func
            install_cuda_cuDNN_5_1_func
            install_cuda_Video_Codec_SDK
	;;
	"install_cuda_Toolkit") echo "Installing install_cuda_Toolkit..."
            install_cuda_Toolkit_func
	;;
	"install_cuda_cuDNN_5_1") echo "Installing install_cuda_cuDNN_5_1..."
            install_cuda_cuDNN_5_1_func
	;;
	"install_Video_Codec_SDK") echo "Installing install_Video_Codec_SDK..."
            install_cuda_Video_Codec_SDK_func
	;;
	*) echo "unknow cmd"
esac

echo "export the following environment to your PATH:"
echo 'export PATH=$PATH:/usr/local/cuda/bin'
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH'


