#!/bin/bash

#configuration options
if [[ !$LUCEE_VERSION ]];then
    export LUCEE_VERSION="5.2.5.20"
    export LUCEE_JAR_SHA256="2f0efdcc2f9f8d1d3f781a81f9e81fa983e52671e6db26d8c02457e27f482146"
fi

if [[ $LUCEE_LIGHT ]];then
    export LUCEE_JAR_SHA256="220133b0aca4e9fc57058fc62320a6b977fc1ec2fdd7860b6c30c4bb9e58de44"
fi

if [[ !$JVM_MAX_HEAP_SIZE ]];then
    export JVM_MAX_HEAP_SIZE="512m"
fi

#set JVM_FILE and JVM_VERSION if you want to use an oracle JVM, instead of openjdk
if [[ !$JVM_FILE ]]; then
    export JVM_FILE="server-jre-8u152-linux-x64.tar.gz"
    export JVM_VERSION="1.8.0_152"
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
