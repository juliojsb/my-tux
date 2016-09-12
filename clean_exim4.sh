#!/bin/bash
#
# Author        :Julio Sanz
# Website       :www.elarraydejota.com
# Tested in OS  :Debian 7/8
# Description   :Script to clean queue and temporary files of Exim4 MTA
# Dependencies  :None
# Usage         :bash clean_exim4.sh
# License       :GPLv3
#

# 
# VARIABLES
#

#
# FUNCTIONS
#

exim_clean(){
	# Remove frozen messages
	exim -bpr | grep frozen | awk '{print $3}' | xargs exim -Mrm

	# Clean var spool Exim folders
	rm -rf /var/spool/exim4/db/*
	rm -rf /var/spool/exim4/input/*
	rm -rf /var/spool/exim4/msglog/*

	# Remove panic log in case it exists
	if [ -f /var/log/exim4/paniclog ];then
		rm /var/log/exim4/paniclog
	fi

	# Restart service
	service exim4 restart
}

exim_status(){
	echo "Current messages in the queue"
	exim -bp
	echo "Current status of exim"
	exiwhat
}

how_to_use(){
    echo "This script is intended to work without parameters"
    echo "Just launch it -> ./clean_exim4.sh"
}

#
# MAIN
#

if [ $# -ne 0 ];then
    how_to_use
else
	exim_clean
	exim_status
fi
