#!/bin/env bash
backup_data=$(date +%Y-%m-%d-%H:%M:%S)
echo "###### wiz stop ######"
docker stop wiz >> /wiz/logs/$backup_data.log
backup_num=$(ls -l /wiz/backup/ | wc -l)

echo "###### wiz backup ######"
zip -r /wiz/backup/$backup_data.zip /wiz/data/ >> /wiz/logs/$backup_data.log

if [ $backup_num -gt 30 ]; then
    cd /wiz/backup/ >> /wiz/logs/$backup_data.log
    rm $(ls -l /wiz/backup/ | head -11 | awk '{print $9}') >> /wiz/logs/$backup_data.log
fi

echo "###### wiz start ######"
docker start wiz >> /wiz/logs/$backup_data.log