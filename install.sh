#!/bin/bash

#configuration options
export LUCEE_INSTALLER="http://railo.viviotech.net/downloader.cfm/id/149/file/lucee-5.0.0.219-RC-pl0-linux-x64-installer.run"

#root permission check
if [ "$(whoami)" != "root" ]; then
  echo "Sorry, you need to run this script using sudo or as root."
  exit 1
fi

function separator {
  echo " "
  echo "------------------------------------------------"
  echo " "
}

#make sure scripts are runnable
chown -R root scripts/*.sh
chmod u+x scripts/*.sh

#update ubuntu software
./scripts/100-ubuntu-update.sh
separator

#download lucee
./scripts/200-lucee.sh
separator

#download commandbox
./scripts/250-commandbox.sh
separator

#install nginx
./scripts/500-nginx.sh
separator

echo "Setup Complete"