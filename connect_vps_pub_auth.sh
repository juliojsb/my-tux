#!/bin/bash
#
# Author        :Julio Sanz
# Website       :www.elarraydejota.com
# Email         :juliojosesb@gmail.com
# Description   :Script to just connect to a remote server with specified parameters
#                using public key authentication
# Usage         :./connect_vps_pub_auth.sh [ IP | hostname ]
# Example       :./connect_vps_pub_auth.sh 192.168.2.105
# License       :GPLv3
#

#
# VARIABLES
#

identity_file=/path/to/id_rsa_file
user="user_to_connect"
ssh_port="22"
remote_server=$1

#
# FUNCTIONS
#

connect_server(){
	ssh -i $identity_file -p $ssh_port $user@$remote_server
}

how_to_use(){
	echo "It's easy, just pass the IP or DNS of the remote server to the script"
    echo "If your private key was generated with a passphrase, you will have to enter it"
	echo "./connect_vps_pub_auth.sh 192.168.2.105"
}

#
# MAIN
# 

if [ $# -ne 1 ];then
	how_to_use
else
	connect_server
fi
