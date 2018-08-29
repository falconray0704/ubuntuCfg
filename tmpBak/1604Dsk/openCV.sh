#!/bin/bash

install_openCV()
{
    sudo apt-get purge libopencv* python-numpy && sudo apt-get autoremove

    sudo rm -rf /usr/local/include/opencv/
    sudo rm -rf /usr/local/include/opencv2/
    sudo rm -rf /usr/local/share/OpenCV/
    sudo find /var/cache/apt/archives/ -name \*opencv\* -exec rm -rf {} \;
    sudo find /usr/local/lib/ -name \*opencv\* -exec rm -rf {} \;
    sudo find /usr/local/bin/ -name \*opencv\* -exec rm -rf {} \;

    echo "Do you want to continue ? [y/N]:"
    read isContinue


    sudo apt-get install build-essential cmake git pkg-config
    sudo apt-get install libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev
    sudo apt-get install libgtk2.0-dev
    sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
    sudo apt-get install libatlas-base-dev gfortran

    sudo apt-get install python2.7-dev libavresample-dev
    sudo -H pip install numpy

    mkdir -p /md/github/openCVs
    cd /md/github/openCVs/
#    git clone https://github.com/Itseez/opencv.git

    #git clone https://github.com/Itseez/opencv_contrib.git
    #cd opencv_contrib
    #git checkout -b 3.0.0
    #cd opencv

    sudo rm -rf opencv-2.4.13.2
    wget -c https://github.com/opencv/opencv/archive/2.4.13.2.tar.gz
    tar -zxf 2.4.13.2.tar.gz
    cd opencv-2.4.13.2

    mkdir build
    cd build
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D INSTALL_C_EXAMPLES=ON \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D WITH_TBB=ON \
        -D BUILD_NEW_PYTHON_SUPPORT=ON \
        -D WITH_V4L=ON \
        -D INSTALL_C_EXAMPLES=ON \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D BUILD_EXAMPLES=ON \
        -D WITH_QT=ON \
        -D WITH_OPENGL=ON \
        -D BUILD_FAT_JAVA_LIB=ON \
        -D INSTALL_TO_MANGLED_PATHS=ON \
        -D INSTALL_CREATE_DISTRIB=ON \
        -D INSTALL_TESTS=ON \
        -D ENABLE_FAST_MATH=ON \
        -D WITH_IMAGEIO=ON \
        -D BUILD_SHARED_LIBS=ON \
        -D WITH_GSTREAMER=ON \
        -D WITH_CUBLAS=ON \
        -D CUDA_NVCC_FLAGS="-D_FORCE_INLINES" ..

        #-D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules

    echo "Do you want to continue ? [y/N]:"
    read isContinue

    make -j4
    sudo make install
    sudo ldconfig


}

install_openCV2()
{
    sudo apt-get purge libopencv* && sudo apt-get autoremove

    sudo rm -rf /usr/local/include/opencv/
    sudo rm -rf /usr/local/include/opencv2/
    sudo rm -rf /usr/local/share/OpenCV/
    sudo find /var/cache/apt/archives/ -name \*opencv\* -exec rm -rf {} \;
    sudo find /usr/local/lib/ -name \*opencv\* -exec rm -rf {} \;
    sudo find /usr/local/bin/ -name \*opencv\* -exec rm -rf {} \;

    echo "Do you want to continue ? [y/N]:"
    read isContinue

    sudo pip install virtualenv virtualenvwrapper
    sudo rm -rf ~/.cache/pip

    sudo apt-get -y install cmake libqt4-dev libgtk2.0-dev libv4l-dev v4l-utils

    sudo apt-get -y install libvisual-0.4-plugins gstreamer0.10-tools gstreamer0.10-plugins-base gstreamer0.10-doc icu-doc tbb-examples libtbb-doc

    sudo apt-get -y install libopencv-dev build-essential checkinstall cmake pkg-config yasm libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22 libdc1394-22-dev libxine2 libxine2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev python-dev python-numpy libtbb-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 libpng12-dev libtiff5-dev unzip


    # optional packages
    sudo apt-get install -y libtbb2 libpng-dev


    mkdir -p /md/github/openCVs
    cd /md/github/openCVs/

    #git clone https://github.com/Itseez/opencv.git
    #cd opencv

    rm -rf opencv-2.4.13.2
    wget -c https://github.com/opencv/opencv/archive/2.4.13.2.tar.gz
    tar -zxf 2.4.13.2.tar.gz
    cd opencv-2.4.13.2

    mkdir build
    cd build

    make clean
    make distclean

    py2Ex=$(which python2)
    py2In=$(python2 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")
    py2Pack=$(python2 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")
    py3Ex=$(which python3)
    py3In=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")
    py3Pack=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")


    cmake -G "Unix Makefiles" \
        -D CMAKE_CXX_COMPILER=/usr/bin/g++ \
        -D CMAKE_C_COMPILER=/usr/bin/gcc \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D WITH_TBB=ON \
        -D BUILD_NEW_PYTHON_SUPPORT=ON \
        -D PYTHON2_EXECUTABLE="$py2Ex" \
        -D PYTHON2_INCLUDE_DIR="$py2In" \
        -D PYTHON2_PACKAGES_PATH="$py2Pack" \
        -D PYTHON3_EXECUTABLE="$py3Ex" \
        -D PYTHON3_INCLUDE_DIR="$py3In" \
        -D PYTHON3_PACKAGES_PATH="$py3Pack" \
        -D WITH_V4L=ON \
        -D INSTALL_C_EXAMPLES=ON \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D BUILD_EXAMPLES=ON \
        -D WITH_QT=ON \
        -D WITH_OPENGL=ON \
        -D BUILD_FAT_JAVA_LIB=ON \
        -D INSTALL_TO_MANGLED_PATHS=ON \
        -D INSTALL_CREATE_DISTRIB=ON \
        -D INSTALL_TESTS=ON \
        -D ENABLE_FAST_MATH=ON \
        -D WITH_IMAGEIO=ON \
        -D BUILD_SHARED_LIBS=ON \
        -D WITH_GSTREAMER=ON \
        -D WITH_CUBLAS=ON \
        -D CUDA_NVCC_FLAGS="-D_FORCE_INLINES" ..


    echo "Do you want to continue to make? [y/N]:"
    read isContinue
    if [ ${isContinue}x = "y"x ] || [ ${isContinue}x = "Y"x ]
    then
        make -j4
    fi

#    cmake -D CMAKE_BUILD_TYPE=RELEASE -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_OPENGL=ON ..


}

install_openCV_cuda()
{
    # install requirements
    sudo apt-get install build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev

    # install optionals
    sudo apt-get install  python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev

    # install openGL requirements
    sudo apt-get install freeglut3-dev mesa-common-dev  libgtkglext1 libgtkglext1-dev

    # install java support requirements
    sudo apt-get install ant

    # install video support requirements
    sudo apt-get install checkinstall yasm libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev libtbb-dev libqt4-dev libgtk2.0-dev libmp3lame-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils

    mkdir -p /md/github/openCVs
    cd /md/github/openCVs

    pwd
    ls -al
    echo ""
    echo "Accomplished dependence installation, isContinue? [y/N]:"
    read isContinue

    if [ ${isContinue}x = "y"x ] || [ ${isContinue}x = "Y"x ]
    then
        echo "Processing..."
    else
        exit 1
    fi

    # download openCV source code
    #wget -c https://github.com/opencv/opencv/archive/2.4.13.2.tar.gz
    rm -rf opencv-2.4.13.2
    tar -zxf 2.4.13.2.tar.gz

    # download openCV contrib support
    #wget -c -O contrib_3.2.0.tar.gz https://github.com/opencv/opencv_contrib/archive/3.2.0.tar.gz
    rm -rf opencv_contrib-3.2.0
    tar -zxf contrib_3.2.0.tar.gz

    # download openCV extra support
    #wget -c -O ex_2.4.13.2.tar.gz https://github.com/opencv/opencv_extra/archive/2.4.13.2.tar.gz
    rm -rf opencv_extra-2.4.13.2
    tar -zxf ex_2.4.13.2.tar.gz

    pwd
    ls -al
    echo " "
    echo "Is Continue to configure? [y/N]:"
    read isContinue

    if [ ${isContinue}x = "y"x ] || [ ${isContinue}x = "Y"x ]
    then
        echo "Processing..."
    else
        exit 1
    fi

    cd opencv-2.4.13.2
    mkdir release
    cd release

    cmake \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D OPENCV_TEST_DATA_PATH=../../opencv_extra-2.4.13.2 \
        -D WITH_CUDA=ON \
        -D WITH_CUBLAS=ON \
        -D CUDA_FAST_MATH=ON \
        -D WITH_CUFFT=ON \
        -D WITH_NVCUVID=ON \
        -D WITH_V4L=ON \
        -D WITH_LIBV4L=ON \
        -D WITH_OPENGL=ON \
        -D WITH_FFMPEG=ON \
        -D INSTALL_C_EXAMPLES=ON \
        -D BUILD_EXAMPLES=ON \
        ..

        #-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-3.2.0/modules \
        #-D BUILD_SHARED_LIBS=OFF

    echo " "
    echo "Is Continue to compile? [y/N]:"
    read isContinue

    if [ ${isContinue}x = "y"x ] || [ ${isContinue}x = "Y"x ]
    then
        echo "Processing..."
    else
        exit 1
    fi

    make -j$(nproc)
    sudo make install

    sudo /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
    sudo ldconfig

#    cd ~/.pyenv/versions/vpy2/lib/python2.7/site-packages
#    ln -s /usr/local/lib/python2.7/site-packages/cv2.so cv2.so

}

case $1 in
	"install") echo "Installing openCV..."
        echo " "
        echo "Before continue, you have to activate Python environment with numpy support."
        echo "isContinue? [y/N]:"
        read isContinue

        if [ ${isContinue}x = "y"x ] || [ ${isContinue}x = "Y"x ]
        then
            install_openCV_cuda
        else
            exit 1
        fi
	;;
	"uninstall") echo "Uninstalling openCV..."
	;;
	*) echo "unknow cmd"
esac







