#!/bin/bash


install_dependence()
{
    sudo apt-get install build-essential libpcre3 libpcre3-dev libssl-dev unzip

}

install_func()
{
    install_dependence

    #Download Nginx source and rtmp module and make / install
    mkdir -p /md/github/nginxs
    cd /md/github/nginxs

    #wget http://nginx.org/download/nginx-1.11.7.tar.gz
    wget http://nginx.org/download/nginx-1.13.1.tar.gz
    wget https://github.com/arut/nginx-rtmp-module/archive/master.zip

    #tar -zxvf nginx-1.11.7.tar.gz
    tar -zxvf nginx-1.13.1.tar.gz
    unzip master.zip

    cd nginx-1.13.1/
    #cd nginx-1.11.7/


    ./configure --with-http_ssl_module --with-http_realip_module --with-http_ssl_module --with-http_v2_module --with-http_flv_module --with-http_mp4_module --add-module=../nginx-rtmp-module-master

    make
    sudo make install


}

help_config()
{

    echo "sudo vim /usr/local/nginx/conf/nginx.conf"
    echo 'rtmp {'
    echo '  server {'
    echo '      listen 1935;'
    echo '      chunk_size 4096;'
    echo '      application myapp {'
    echo '      live on;'
    echo '      }'
    echo '      application hls {'
    echo '      live on;'
    echo '      hls on;'
    echo '      hls_path /tmp/hls;'
    echo '      }'
    echo '  }'
    echo '}'
}

help_use()
{
    echo "Push cmd:"
    echo 'ffmpeg -re -i ./aWalkToUnionSquare.mp4 -c copy -f flv rtmp://10.1.51.20:1935/myapp/aWalkToUnionSquare'

    echo "Play cmd"
    echo 'ffplay rtmp://10.1.51.20:1935/myapp/aWalkToUnionSquare'
}

case $1 in
	"install") echo "Installing nginx with rtmp module..."
            install_func
            help_config
	;;
	"start") echo "Starting ..."
        sudo /usr/local/nginx/sbin/nginx
	;;
	"reload") echo "Reload config ..."
        sudo /usr/local/nginx/sbin/nginx -s reload
        echo "Reload accomplished!"
	;;
	"config") echo "Follow these steps to config"
        help_config
	;;
	"help") echo "Follow these steps to config"
        help_use
	;;
	*) echo "unknow cmd"
esac


