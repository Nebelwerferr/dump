#!/bin/bash

#Variables : 
OSCodeName=$(lsb_release -c -s)

###################################################################################

sudo apt-get -y update
sudo apt-get -y upgrade

if [ "$OSCodeName" = "noble" ]; then
	echo "Impossible to upgrade"	
elif [ "$OSCodeName" = "jammy" ]; then
   sed -i 's/jammy/noble/g' /etc/apt/sources.list
elif [ "$OSCodeName" = "focal" ]; then
    sed -i 's/focal/jammy/g' /etc/apt/sources.list
elif [ "$OSCodeName" = "bionic" ]; then
    sed -i 's/bionic/focal/g' /etc/apt/sources.list
else
    echo "ERROR"
fi

sudo apt-get -y update
sudo apt-get -y upgrade

sudo reboot
