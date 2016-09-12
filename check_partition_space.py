#!/usr/bin/env python2
"""
Author        :Julio Sanz
Website       :www.elarraydejota.com
Email         :juliojosesb@gmail.com
Description   :Python script to check space occupation of a partition and send mail
               in case it surpasses a given value. It uses Google SMTP by default, change
               as you need
Dependencies  :This scrip has been written using Python 2.7.9
Usage         :chk_partition_space.py [partition]
Example       :chk_partition_space.py /home
License       :GPLv3
"""

#
# IMPORTS
#

import os,sys,smtplib

#
# VARIABLES
#

partition=sys.argv[1]
alert_value=90 # Alert threshold in % of disk space occupation
server=os.uname()[1]
mail_to="yourmail@gmail.com"
mail_password="your_mail_password"
smtp_server="smtp.gmail.com"

#
# FUNCTIONS
#

def check_partition():
    chk_partition = os.statvfs(partition)
    total = chk_partition.f_blocks * chk_partition.f_frsize
    used = (chk_partition.f_blocks - chk_partition.f_bfree) * chk_partition.f_frsize
    percentage_used = (100 * used)/total
    if percentage_used > alert_value:
        send_mail(percentage_used)

def send_mail(percentage_used):
    message = """From: From %s
To: To %s
Subject: Warning!! Percentaje usage of partition %s = %s %%

Please check affected partition and take action:
    - Compress logs
    - Delete data not needed
    - Add more space to partition
""" % (server, mail_to, partition, percentage_used)
    s = smtplib.SMTP(smtp_server, 587)
    s.starttls()
    s.login(mail_to, mail_password)
    s.sendmail(server, mail_to, message)
    s.quit()

#===============
# MAIN
#===============

if __name__ == '__main__':
    check_partition()
