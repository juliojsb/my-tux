#!/bin/bash
#
# Author        :Julio Sanz
# Website       :www.elarraydejota.com
# Email         :juliojosesb@gmail.com
# Tested in     :Debian Wheezy/Jessie, RHEL/CentOS/Fedora 6/7
# Description   :Script to check used space in a partition and send email in case
#                it exceeds the threshold value
# Usage         :1- chmod +x check_partition_space.sh
#                2- ./check_partition_space.sh
# License       :GPLv3
#

#
# VARIABLES
#

mail="your_email"
partition="/path/to/partition/to/check"
# Once % occupation exceeds threshold value, an email is sent to notify
threshold_value="80"
# NOTE: in your system, check if the column 4 matches with the percentage number.
# On some systems is column 4 and in other, column 5
used_space=$(df -h $partition | head -3 | tail -1 | tr -s "%" " " | awk '{print $4}')

#
# FUNCTIONS
#

chk_partition_space(){
    if [ "$used_space" -gt "$threshold_value" ];then
        echo "ALERT!, Disk partition $partition occupation > $threshold_value % in $(hostname)" \
        | mail -s "ALERT!, Disk partition $partition occupation > $threshold_value % in $(hostname)" "$mail"
    fi
}

how_to_use(){
    echo "This script is intended to work without parameters"
    echo "Just launch it -> ./check_partition_space.sh"
}

#
# MAIN
# 

if [ $# -ne 0 ];then
    how_to_use
else
    chk_partition_space
fi
