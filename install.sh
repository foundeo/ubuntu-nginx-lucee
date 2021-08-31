#!/bin/bash

#configuration options
if [[ "$LUCEE_VERSION" == "" ]];then
    export LUCEE_VERSION="5.3.7.48"
fi

#if [[ "$LUCEE_LIGHT" == "" ]];then
    #export LUCEE_JAR_SHA256=""
#fi

if [[ "$JVM_MAX_HEAP_SIZE" == "" ]];then
    export JVM_MAX_HEAP_SIZE="512m"
fi


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

#configure lucee
./scripts/600-config.sh
separator

echo "Setup Complete"
separator
