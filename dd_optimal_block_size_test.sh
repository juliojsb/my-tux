#!/bin/bash
#
# Author        :Julio Sanz
# Website       :www.elarraydejota.com
# Email         :juliojosesb@gmail.com
# Tested in     :Debian Wheezy/Jessie, CentOS 7/6
# Description   :Script to check the optimal block size for a given device, useful to test with external drives
# Dependencies  :None
# Usage         :./dd_optimal_block_size_test.sh
# License       :GPLv3
#

#
# VARIABLES
#

# Add as many as you want
blocks_to_check="1k 2k 4k 8k 16K 32K 64K 128K 256K 512K 1M 2M 4M 8M 16M"
# A temporary test file
test_file="/var/tmp/test_file"
# CAUTION!!! Check this variable output_destination carefully, dd will overwrite
# content of the device set as output_destination during this test
output_destination="/dev/sdc"
# To determine the size of the test file
count_n=128000

#
# FUNCTIONS
#

block_size_test(){
    # Create test file
    dd if=/dev/zero of=$test_file count=$count_n > /dev/null 2>&1

    echo "---------Begin block size test----------"

    for block_size in $blocks_to_check
    do
            result=`dd if=$test_file of=$output_destination bs=$block_size 2>&1 1>/dev/null`
            time_spent=`echo $result | cut -d "," -f2`
            speed=`echo $result | cut -d "," -f3`
            echo "Block Size $block_size --- It took $time_spent --- Speed $speed"
    done

    # Remove test file
    rm $test_file
}

how_to_use(){
    echo "This script is intended to work without parameters"
    echo "Just launch it -> ./dd_optimal_block_size_test.sh"
}

#
# MAIN
#

if [ $# -ne 0 ];then
    how_to_use
else
	block_size_test
fi
