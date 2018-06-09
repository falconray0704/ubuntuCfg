#!/bin/bash

install_dependence_func()
{
    sudo apt-get install gstreamer1.0-plugins-bad gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools libgstreamer1.0-dev libgstreamer1.0-0-dbg libgstreamer1.0-0 gstreamer1.0-omx gstreamer1.0-omx-dbg libgstreamer-plugins-base1.0-dev gtk-doc-tools

}

install_cam_source_func()
{
    mkdir -p /opt/github/rtspServer

    pushd /opt/github/rtspServer
    git clone https://github.com/thaytan/gst-rpicamsrc.git
    pushd gst-rpicamsrc
    ./autogen.sh
    make
    sudo make install
    popd
    popd
}

install_rtsp_server_lib()
{
    mkdir -p /opt/github/rtspServer

    pushd /opt/github/rtspServer
    git clone git://anongit.freedesktop.org/gstreamer/gst-rtsp-server
    pushd gst-rtsp-server
    git checkout 1.4
    ./autogen.sh
    make
    sudo make install
    popd
    popd
}

case $1 in
	"install_dependence") echo "Install dependence ..."
        install_dependence_func
	;;
	"install_cam_source") echo "Install camera source..."
        install_cam_source_func
	;;
	"install_rtsp_server_lib") echo "Install rtsp server library..."
        install_rtsp_server_lib_func
	;;
	"check_cam_source") echo "Check camera source..."
        gst-inspect-1.0 |grep rpicamsrc
        gst-inspect-1.0 rpicamsrc
	;;
	"launch rtsp server") echo "launch rtsp server ..."
        pushd /opt/github/rtspServer/gst-rtsp-server/examples
        ./test-launch "( rpicamsrc preview=false bitrate=2000000 keyframe-interval=15 ! video/x-h264, framerate=15/1 ! h264parse ! rtph264pay name=pay0 pt=96 )"
        popd
	;;
	"test_rtsp_server_lib") echo "Test rtsp server library..."
        GST_DEBUG=3 gst-launch-1.0 -v rpicamsrc preview=false bitrate=2000000 keyframe-interval=15 ! video/x-h264, framerate=15/1 ! h264parse ! fakesink silent=false
	;;
	"test_cam_source") echo "Test camera source..."
        echo "By now, cam view should be seen on pi screen..."
        GST_DEBUG=3 gst-launch-1.0 -v rpicamsrc keyframe-interval=30 ! fakesink silent=false
	;;
	*) echo "unknow cmd"
esac

