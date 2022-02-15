#!/bin/env bash
set -ex

Docker_backup(){
    backup_data=$1-$(date +%Y-%m-%d-%H:%M:%S)
    echo -e "\n###### Docker Stop $1 ######\n" >> $Logs_path/$backup_data.log
    docker stop $1 >> $Logs_path/$backup_data.log
    backup_num=$(ls -l $Backup_path/$1* | wc -l)
    echo -e "\n###### $1 Backup ######\n" >> $Logs_path/$backup_data.log
    zip -r $Backup_path/$backup_data.zip /docker/$2/ >> $Logs_path/$backup_data.log
    if [ $backup_num -gt 15 ]; then
        echo -e "\n###### $1 Delete Old Backups ######\n" >> $Logs_path/$backup_data.log
        cd $Backup_path/ >> $Logs_path/$backup_data.log
        rm $(ls -l $Backup_path/$1* | head -11 | awk '{print $9}') >> $Logs_path/$backup_data.log
        rm $(ls -l $Logs_path/$1* | head -11 | awk '{print $9}') >> $Logs_path/$backup_data.log
    fi
    echo -e "\n###### $1 Start ######\n" >> $Logs_path/$backup_data.log
    docker start $1 >> $Logs_path/$backup_data.log
}
# ENV
Logs_path="/docker/logs"
Backup_path="/docker/backup"
# MAIN
Docker_backup wiz wizdate
