#!/bin/bash

#configuration options
export RAILO_VERSION="4.2.1.008"
export JVM_MAX_HEAP_SIZE="512m"
export JVM_FILE="server-jre-8u25-linux-x64.gz"
export JVM_VERSION="1.8.0_25"

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

#download railo
./scripts/200-railo.sh
separator

#install tomcat
./scripts/300-tomcat.sh
separator

#install jvm
./scripts/400-jvm.sh
separator

#install nginx
./scripts/500-nginx.sh
separator

echo "Setup Complete"
separator
echo "GO SET YOUR RAILO PASSWORDS: http://localhost/railo-context/admin/server.cfm"
