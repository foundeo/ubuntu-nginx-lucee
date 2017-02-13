#!/bin/bash

#configuration options
export LUCEE_VERSION="5.1.0.34"
export JVM_MAX_HEAP_SIZE="512m"

#set these two variables if you want to use an oracle JVM, instead of openjdk
export JVM_FILE="server-jre-8u66-linux-x64.tar.gz"
export JVM_VERSION="1.8.0_66"


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
echo "GO SET YOUR LUCEE PASSWORDS: http://localhost/lucee/admin/server.cfm"
