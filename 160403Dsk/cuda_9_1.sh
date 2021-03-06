#!/bin/bash

install_cuda_Toolkit_example_func()
{
    export PATH=/usr/local/cuda-9.1/bin${PATH:+:${PATH}}
    export LD_LIBRARY_PATH=/usr/local/cuda-9.1/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

    sudo apt-get install g++ freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev
    cp -a /usr/local/cuda-9.1/samples ~/NVIDIA_CUDA-9.1_Samples
    cd ~/NVIDIA_CUDA-9.1_Samples
    make
    cd -

}

install_cuda_Toolkit_func()
{
    cd cuda9.1
    sudo dpkg -i cuda-repo-ubuntu1604-9-1-local_9.1.85-1_amd64.deb
    sudo apt-key add /var/cuda-repo-9-1-local/7fa2af80.pub
    sudo apt-get update
    sudo apt-get install cuda

    #echo "export the following environment to your PATH:"
    echo "" >> ~/.bashrc
    echo '# cuda ToolKit:' >> ~/.bashrc
    #echo 'export PATH=$PATH:/usr/local/cuda/bin' >> ~/.bashrc
    echo 'export PATH=/usr/local/cuda-9.1/bin${PATH:+:${PATH}}' >> ~/.bashrc
    #echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-9.1/lib64\${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
    echo "" >> ~/.bashrc

    sudo dpkg -i cuda-repo-ubuntu1604-9-1-local-cublas-performance-update-1_1.0-1_amd64.deb
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get dist-upgrade
}

install_cuda_cuDNN_9_1_func()
{
    rm -rf /opt/nvidia/cuDNNs/cuDNN_9_1
    mkdir -p /opt/nvidia/cuDNNs/cuDNN_9_1

    tar -zxf cudnn-9.1/cudnn-9.1-linux-x64-v7.tgz -C /opt/nvidia/cuDNNs/cuDNN_9_1

    sudo cp /opt/nvidia/cuDNNs/cuDNN_9_1/cuda/include/cudnn.h /usr/local/cuda/include
    sudo cp /opt/nvidia/cuDNNs/cuDNN_9_1/cuda/lib64/libcudnn* /usr/local/cuda/lib64
    sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

    #echo "" >> ~/.bashrc
    #echo '# cuDNN:' >> ~/.bashrc
    #echo 'export LD_LIBRARY_PATH=/md/nvidia/cuDNNs/cuDNN_5_1/cuda:$LD_LIBRARY_PATH' >> ~/.bashrc
    #echo "" >> ~/.bashrc

    #sudo cp -a cuda/include/* /usr/local/cuda/include/
    #sudo cp -a cuda/lib64/* /usr/local/cuda/lib64/

}

install_cuda_Video_Codec_SDK_func()
{
    mkdir -p /md/nvidia/Video_Codec_SDKs
    cd /md/nvidia/Video_Codec_SDKs

    rm -rf Video_Codec_SDK_8.0.14
    cp /md/etmp/nvidia/Video_Codec_SDK_8.0.14.zip ./
    unzip Video_Codec_SDK_8.0.14.zip

    ls -al Video_Codec_SDK_8.0.14
    sudo cp -r Video_Codec_SDK_8.0.14/Samples/common/inc/* /usr/include/

}

checkEnvFunc()
{
    echo "=== Verify You Have a CUDA-Capable GPU"
    lspci | grep -i nvidia
    echo "=== Verify You Have a Supported Version of Linux"
    uname -m && cat /etc/*release
    echo "=== Verify the System Has gcc Installed"
    gcc --version
    echo "=== Verify the System has the Correct Kernel Headers and Development Packages Installed"
    uname -r
    sudo apt-get install linux-headers-$(uname -r)
}


cd /opt/etmp/cudaSDK9/

case $1 in
    "checkEnv") echo "Checking environment ..."
            checkEnvFunc
    ;;
	"install_cuda_Toolkit") echo "Installing install_cuda_Toolkit..."
            install_cuda_Toolkit_func
	;;
	"install_cuda_Toolkit_example") echo "Installing install_cuda_Toolkit_example..."
            install_cuda_Toolkit_example_func
	;;
	"install_cuda_cuDNN_9_1") echo "Installing install_cuda_cuDNN_9_1..."
            install_cuda_cuDNN_9_1_func
	;;
	"install_Video_Codec_SDK") echo "Installing install_Video_Codec_SDK..."
            install_cuda_Video_Codec_SDK_func
	;;
	"install") echo "Installing all..."
            install_cuda_Toolkit_func
            install_cuda_cuDNN_9_1_func
            install_cuda_Video_Codec_SDK
	;;
	*) echo "unknow cmd"
esac



