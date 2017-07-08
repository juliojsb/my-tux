#!/bin/bash
#
# Title         :mysql_info.sh
# Author        :Julio Sanz
# Website       :www.juliojosesanz.com
# Email         :juliojosesb@gmail.com
# Description   :Script to retrieve basic information and statistics from MySQL server
# Dependencies  :None
# Usage         :./mysql_info.sh
# License       :GPLv3
#
###############################################################################################

#============================================
# VARIABLES
#============================================

# Base64 encoding for the password
# Parse the original password with -> echo "password" | base64 
# Then paste the result in the variable mysql_enc_pass
# For example for the string "password" the encoded result is cGFzc3dvcmQK
mysql_enc_pass="cGFzc3dvcmQK"
mysql_dec_pass=`echo "$mysql_enc_pass" | base64 --decode`
mysql_user="mydbuser"

#============================================
# FUNCTIONS
#============================================

function get_mysql_stats(){
    echo "=========================================="
    echo "MySQL version information"
    echo ""
    mysql -u $mysql_user -p"$mysql_dec_pass" -e 'show variables like "%version%";'

    echo "=========================================="
    echo "Currently active databases"
    echo ""
    mysql -u $mysql_user -p"$mysql_dec_pass" -e 'show databases;'

    echo "=========================================="
    echo "List of processes"
    echo ""
    mysql -u $mysql_user -p"$mysql_dec_pass" -e 'show full processlist;'

    echo "=========================================="
    echo "General status information"
    echo ""
    mysql -u $mysql_user -p"$mysql_dec_pass" -e 'show status where Variable_name REGEXP "innodb|Open|Qcache|Bytes";'
}

#============================================
# MAIN
#============================================

get_mysql_stats
