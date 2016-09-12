#!/usr/bin/env python2
"""
Author        :Julio Sanz
Website       :www.elarraydejota.com
Email         :juliojosesb@gmail.com
Description   :Script to automate the execution of a list of tasks in remote server/s
               Just pass the server/s IP or hostname as an argument
               The same credentials are used for all servers, so it is assumed that
               the same user/password is used in all of them to connect via SSH
Dependencies  :paramiko
Usage         :ssh_paramiko_automate.py [ IP/hostname ]
Examples      :./ssh_paramiko_automate.py 192.168.2.156
               ./ssh_paramiko_automate.py 192.168.2.156 192.168.2.30 server3
License       :GPLv3
"""

#
# IMPORTS
#

import paramiko, getpass, sys

#
# VARIABLES
#

# Add to the list of boring tasks you want to send to the
# remote server/s. This is just an example:
remote_commands = [ 'updatedb', 'ls -l /home/jota', \
                    '/opt/wordpress/wp_backup.sh', '/opt/wordpress/post_backup.sh' ]

#
# FUNCTIONS
#

def connect_ssh():
    #v_remoteserver = raw_input("Remote server IP/hostname: ")
    v_username = raw_input("Username: ")
    v_password = getpass.getpass("Password: ")

    for v_remoteserver in sys.argv[1:]:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(v_remoteserver, username=v_username, password=v_password)
        print "============================================================================"
        print "--------========Executing commands in server "+v_remoteserver+"========---------"

        for order in remote_commands:
            print "_"*60
            print "Executing command ---> "+order+"\n"
            stdin, stdout, ssh_stderr = ssh.exec_command(order)
            print (stdout.read())

        ssh.close()

#
# MAIN
#

if __name__ == '__main__':
    connect_ssh()
