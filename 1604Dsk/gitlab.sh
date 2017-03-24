#!/bin/bash

git_data_dir="gitlabRepo"

install_nfs_git_data_dir()
{
    echo "Local nfs gitlab data path:${1}/${git_data_dir} is going to be built up!"

    sudo mkdir -p "${1}/${git_data_dir}"
    sudo chown -hR git "${1}/${git_data_dir}"

    sudo mkdir -p "/opt/${git_data_dir}"
    sudo chown -hR git "/opt/${git_data_dir}"

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

        sudo gitlab-ctl stop
        sudo gitlab-ctl upgrade
        sudo gitlab-ctl start


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

install_gitlab()
{
    sudo apt-get install curl openssh-server ca-certificates postfix
    curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
    sudo apt-get install gitlab-ce
    sudo gitlab-ctl reconfigure


    sudo systemctl disable gitlab-runsvdir.service
#    sudo systemctl enable gitlab-runsvdir.service

}

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

    #git_data_dirs({ "default" => { "path" => "/var/opt/gitlab/git-data" } })
    #gitlabRepoPath=$(echo "${nfs_git_data_path}/${git_data_dir}" | sed 's/\//\\\//g')
    #cat /etc/gitlab/gitlab.rb | sed /"*git_data_dirs*\/var\/opt\/gitlab\/git-data"/d > './exports.tmp'

    echo 'Please reconfig the "git_data_dirs" in /etc/gitlab/gitlab.rb, press any key to continue.'
    read tmp
    sudo vim /etc/gitlab/gitlab.rb
    #sudo rsync -av /var/opt/gitlab/git-data/repositories ${nfs_git_data_path}/${git_data_dir}

}

if [ $UID -ne 0 ]
then
    echo "Superuser privileges are required to run this script."
    echo "e.g. \"sudo $0\""
    exit 1
fi

#/dev/sdb1 /md ext4
isMounted=`cat '/etc/mtab' | grep '/dev/sdb1 /md ext4'`
if [ ! -n "$isMounted" ]
then
    echo ${isMounted}
    echo '/md does not be mounted, please check it first!'
    exit 1
fi


case $1 in
	"install") echo "Installing..."
            install_gitlab
	;;
	"uninstall") echo "Uninstall..."
            uninstall_nfs_git_data_dir
	;;
	"reconfig") echo "Reconfig gitlab repo nfs path..."
            echo "Do you want to config gitlabRepo path mount to nfs server? [y/N]:"
            read isConfig
            if [ ${isConfig}x = "y"x ] || [ ${isConfig}x = "Y"x ]
            then
                sudo gitlab-ctl stop
                sudo systemctl stop gitlab-runsvdir.service

                reconfig_gitlab_repo_location

                sudo gitlab-ctl upgrade
                sudo gitlab-ctl reconfigure

                sudo systemctl start gitlab-runsvdir.service
                sudo gitlab-ctl start
            fi
	;;
	"start") echo "starting..."
            sudo gitlab-ctl stop
            sudo systemctl stop gitlab-runsvdir.service
            sudo umount "/opt/${git_data_dir}"
            exportedPath=`cat /etc/exports_gitlab_data_path`
            sudo mount -t nfs -o rw,resvport 127.0.0.1:"${exportedPath}" "/opt/${git_data_dir}"
            sudo systemctl start gitlab-runsvdir.service
            sudo gitlab-ctl start
	;;
	"restart") echo "restarting..."
            sudo gitlab-ctl stop
            sudo systemctl stop gitlab-runsvdir.service
            sudo umount "/opt/${git_data_dir}"
            exportedPath=`cat /etc/exports_gitlab_data_path`
            sudo mount -t nfs -o rw,resvport 127.0.0.1:"${exportedPath}" "/opt/${git_data_dir}"
            sudo systemctl start gitlab-runsvdir.service
            sudo gitlab-ctl start
	;;
	"stop") echo "stop..."
            sudo gitlab-ctl stop
            sudo systemctl stop gitlab-runsvdir.service
            sudo umount "/opt/${git_data_dir}"
	;;
	"test") echo "testing..."
            echo "test cmd."
	;;
	*) echo "unknow cmd"
esac


#uninstall_nfs_git_data_dir ${nfs_git_data_path}


