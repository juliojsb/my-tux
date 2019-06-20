#!/bin/bash
#
# Backup of InfluxDB databases to filesystem location
#


# ----
# VARIABLES

influxdb_host="localhost"
dblist=( collectd_db telegraf_db )
backupdir="/backups/influxdb"
retention="20" # Days


# ----
# MAIN

for db in "${dblist[@]}";do
    if [ ! -d ${backupdir}/${db}/$(date +%Y%m%d) ];then
        mkdir -p ${backupdir}/${db}/$(date +%Y%m%d)
        echo "---------------------------------------------------"
        echo "> Backup database $db"
        influxd backup -portable -database ${db} -host ${influxdb_host}:8088 ${backupdir}/${db}/$(date +%Y%m%d)/
    else
        echo "Backup already exists"
    fi
    # Delete old backups
    find ${backupdir}/${db} -mindepth 1 -type d -mtime +${retention} -exec rm -rf {} \;
done
