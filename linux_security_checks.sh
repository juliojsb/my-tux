#!/bin/bash
#
# Author        :Julio Sanz
# Website       :www.elarraydejota.com
# Email         :juliojosesb@gmail.com
# Tested in     :Debian 8 Jessie
# Description   :Script to automate the security checks of a Linux system with the
#                utilities clamav,lynis,chkrootkit and rkhunter
#                Designed to be used with a crontab, so it is launched certain days. For example:
#                --Partial scan on Thursday and Wednesday
#                00 19 * * 1,3 /root/linux_security_checks.sh partial
#                --Full scan on Friday
#                00 19 * * 5 /root/linux_security_checks.sh full
# Dependencies  :- For the security checks, you need to have installed:
#                  * ClamAV
#                  * Lynis
#                  * Chkrootkit
#                  * Rkhunter
#                - If you enable mail notification to an external account (@gmail for example), you need to install
#                  and configure SSMTP or any other MTA
#                  For SSMTP configuration check:
#                  http://www.elarraydejota.com/ssmtp-reenviar-correos-desde-el-sistema-sin-complicarnos-la-vida/
# Usage         :1) Give executable permissions to script -> chmod +x linux_security_checks.sh
#                2) Execute script -> ./linux_security_checks.sh [ partial | full ]
# License       :GPLv3
#

# 
# VARIABLES
#

# Partial/full
script_option="$1"
# Binaries
rkhunter_b="/usr/bin/rkhunter"
chkrootkit_b="/usr/sbin/chkrootkit"
clamscan_b="/usr/bin/clamscan"
lynis_b="/usr/sbin/lynis"
# Additional variables
results_log="/var/log/linux_security_checks.log"
clamav_additional_options="--bytecode=yes --scan-mail=yes --phishing-sigs=yes --phishing-scan-urls=yes"
# Send mail notification? -> y/n
send_mail="y"
email_to="youraccount@example.com"

#
# FUNCTIONS
#

full_scan() {
	# Update ClamAV signatures
	freshclam > /dev/null
	# Update Rkhunter signatures
	$rkhunter_b --update > /dev/null

	# Begin the scan
	echo "---------------${script_option} security scan in machine $(hostname)---------------" > $results_log
	# ClamAV scan
	echo -e "\n\n==========CLAMAV SCAN" >> $results_log
	$clamscan_b -ri / --exclude-dir=/sys --exclude-dir=/proc $clamav_additional_options >> $results_log
	# Current network connections
	echo -e "\n\n==========CURRENT NETWORK CONNECTIONS" >> $results_log
	netstat -netaup >> $results_log
	# Lastlog (most recent logins)
	echo -e "\n\n==========LASTLOG (MOST RECENT LOGINS)" >> $results_log
	lastlog >> $results_log
	# Last (last logged users)
	echo -e "\n\n==========LAST (LAST LOGGED USERS)" >> $results_log
	last >> $results_log
	# Chkrootkit scan
	echo -e "\n\n==========CHKROOTKIT SCAN" >> $results_log
	$chkrootkit_b -q >> $results_log
	# Rkhunter scan
	echo -e "\n\n==========RKHUNTER SCAN" >> $results_log
	$rkhunter_b --check --nocolors --skip-keypress --report-warnings-only >> $results_log
	# Lynis scan
	echo -e "\n\n==========LYNIS SCAN" >> $results_log
	$lynis_b --cronjob --nolog >> $results_log

	# Finally send email notification with information
	if [ $send_mail == "y" ];then
		send_notification
	fi
}

partial_scan() {
	# Update ClamAV signatures
	freshclam > /dev/null

	# Scan system using ClamAV antivirus
	echo "---------------${script_option} security scan in machine $(hostname)---------------" > $results_log
	# ClamAV scan
	echo -e "\n\n==========CLAMAV SCAN" >> $results_log
	$clamscan_b -ri / --exclude-dir=/home --exclude-dir=/media --exclude-dir=/sys \
	--exclude-dir=/proc $additional_options >> $results_log
	# Current network connections
	echo -e "\n\n==========CURRENT NETWORK CONNECTIONS" >> $results_log
	netstat -netaup >> $results_log
	# Lastlog (most recent logins)
	echo -e "\n\n==========LASTLOG (MOST RECENT LOGINS)" >> $results_log
	lastlog >> $results_log
	# Last (last logged users)
	echo -e "\n\n==========LAST (LAST LOGGED USERS)" >> $results_log
	last >> $results_log

	# Finally send email notification with information
	if [ $send_mail == "y" ];then
		send_notification
	fi
}

send_notification() {
	echo "${script_option} security scan in machine $(hostname)" | mail -s \
	"Results of ${script_option} security scan in machine $(hostname)" $email_to < $results_log
}

how_to_use() {
	echo "----Some help for the usage of this script"
	echo "To launch -> ./linux_security_checks.sh [ partial | full ]"
	echo "Available options:"
	echo "	partial   Perform a partial ClamAV scan of your system, excluding some directories."
	echo "            No rootkit, vulnerabilities or hardening scan will be performed."
	echo "	full      Perform a full scan of all your system with ClamAV, rkhunter, chkrootkit and lynis"
	echo "            hardening analysis."
}

#
# MAIN
#

if [ $# -lt 1 ];then
	echo "Wrong syntax, please check usage"
	how_to_use
	exit 1
else
	case $script_option in
		full )	full_scan ;;
		partial )	partial_scan ;;
		* )	echo "Wrong syntax, please check usage"
			how_to_use
			exit 1
			;;
