#!/bin/bash

if [[ $SKIP_UBUNTU_UPDATE ]];then
    echo "Skipping Ubuntu Update"
else 
    echo "Updating Ubuntu Software"
    apt-get update
fi

if [[ $SKIP_UBUNTU_UPGRADE ]];then
    echo "Skipping Ubuntu Upgrade"
else 
    echo "Upgrading Ubuntu Software"
    apt-get upgrade
fi

apt-get install unzip curl apt-transport-https gnupg
