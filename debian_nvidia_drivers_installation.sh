#!/bin/bash
#
# Author        :Julio Sanz
# Website       :www.elarraydejota.com
# Description   :script to install Nvidia propietary drivers in Debian GNU/Linux
# Tested in     :Debian Wheezy/Jessie
# Usage         :Just launch the script -> ./debian_nvidia_drivers_installation.sh
# License       :GPLv3
#
########################################################################################################

#
# VARIABLES
#

# Detect Nvidia card model
NVIDIA_CARD=$(nvidia-detect)

#
# FUNCTIONS
#

driver_installation(){
    echo "Detected Nvidia card >>> $NVIDIA_CARD"
    echo "Installing drivers..."

    # Install Nvidia kernel driver and linux-headers
    aptitude -r install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') nvidia-kernel-dkms nvidia-settings nvidia-glx

    # X.org configuration file
    mkdir /etc/X11/xorg.conf.d
    echo -e 'Section "Device"\n\tIdentifier "${NVIDIA_CARD}"\n\tDriver "nvidia"\nEndSection' > /etc/X11/xorg.conf.d/20-nvidia.conf

    echo "Done. Now, just reboot your machine"
}

how_to_use(){
    echo "This script is intended to work without parameters"
    echo "Just launch it -> ./debian_nvidia_drivers_installation.sh"
}

#
# MAIN
#

if [ $# -ne 0 ];then
    how_to_use
else
	driver_installation
fi
