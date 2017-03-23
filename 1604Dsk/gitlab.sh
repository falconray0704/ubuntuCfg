#!/bin/bash

git_data_dir="gitlabRepo"

install_nfs_git_data_dir()
{
    echo "Local nfs gitlab data path:${1}/${git_data_dir} is going to be built up!"
    sudo mkdir -p "${1}/${git_data_dir}"
    sudo mkdir -p "/opt/${git_data_dir}"

    nfsServerExport="${1}/${git_data_dir} 127.0.0.1(rw,sync,no_root_squash,no_subtree_check)"

    echo 'Backup /etc/exports to /etc/exports_before_install_nfs_git_data_path'
    sudo cp /etc/exports /etc/exports_before_install_nfs_git_data_path
    sudo echo "${1}/${git_data_dir}" > /etc/exports_gitlab_data_path

    grepPath=$(echo "${1}/${git_data_dir}" | sed 's/\//\\\//g')
    isExisted=`cat '/etc/exports' | grep ${grepPath}`

    if [ ! -n "$isExisted" ]
    then
        #echo "no"
        sudo echo ${nfsServerExport} >> /etc/exports
        sudo service nfs-kernel-server restart
        sudo mount -t nfs -o rw,resvport 127.0.0.1:"${1}/${git_data_dir}" "/opt/${git_data_dir}"
    else
        echo "${1} already be exported"
        exit 1
    fi

}


uninstall_nfs_git_data_dir()
{
    echo "nfs gitlab data path:/opt/${git_data_dir} is being unmounted!"
    sudo umount "/opt/${git_data_dir}"

    exportedPath=`cat /etc/exports_gitlab_data_path`
    sedPath=$(echo "${exportedPath}" | sed 's/\//\\\//g')
    nfsServerExport="${sedPath} 127.0.0.1(rw,sync,no_root_squash,no_subtree_check)"

    echo 'Backup /etc/exports to /etc/exports_before_uninstall_nfs_git_data_dir'
    sudo cp /etc/exports /etc/exports_before_uninstall_nfs_git_data_dir

#    echo ${nfsServerExport}
    cat '/etc/exports' | sed /"${nfsServerExport}"/d > './exports.tmp'

    sudo cp ./exports.tmp /etc/exports
}


if [ $UID -ne 0 ]
then
    echo "Superuser privileges are required to run this script."
    echo "e.g. \"sudo $0\""
    exit 1
fi

reconfig_gitlab_repo_location()
{
    sudo apt install nfs-kernel-server
    sudo systemctl start nfs-kernel-server.service

    nfs_git_data_path=
    echo 'Please input the absolute path which use to store "gitlabRepo"(gitlab repo data storage path):'
    read nfs_git_data_path
    if [ ! -n "$nfs_git_data_path" ]
    then
        echo "Invalid path!"
        exit 1
    fi
    install_nfs_git_data_dir ${nfs_git_data_path}
    #config_git_data_dir '/md/gitlabRepo'

}

case $1 in
	"install") echo "Installing..."



            echo "Do you want to config gitlabRepo path mount to nfs server? [y/N]:"
            read isConfig
            if [ ${isConfig}x = "y"x ] || [ ${isConfig}x = "Y"x ]
            then
                reconfig_gitlab_repo_location
            fi
	;;
	"uninstall") echo "Uninstall..."
            uninstall_nfs_git_data_dir
	;;
	"reconfig") echo "Reconfig gitlab repo nfs path..."
	;;
	*) echo "unknow cmd"
esac


#uninstall_nfs_git_data_dir ${nfs_git_data_path}


