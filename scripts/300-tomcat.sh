#!/bin/bash

echo "Installing Tomcat 8"
apt-get install tomcat8

echo "Configuring Tomcat"

mkdir backup
mkdir backup/etc
mkdir backup/etc/tomcat8
mkdir backup/etc/default
#backup default tomcat web.xml
cp /etc/tomcat8/web.xml backup/etc/tomcat8/web.xml-orig-backup
#copy our web.xml to tomcat directory
cp etc/tomcat8/web.xml /etc/tomcat8/

#backup default server.xml
cp /etc/tomcat8/server.xml backup/etc/tomcat8/server.xml-orig-backup
#copy our server.xml to tomcat dir
cp etc/tomcat8/server.xml /etc/tomcat8/

#backup default catalina.properties
cp /etc/tomcat8/catalina.properties backup/etc/tomcat8/catalina.properties-orig-backup
#copy our catalina properties
cp etc/tomcat8/catalina.properties /etc/tomcat8/

cp /etc/default/tomcat8 backup/etc/default/tomcat8

echo "Installing mod_cfml Valve for Automatic Virtual Host Configuration"
if [ -f lib/mod_cfml-valve_v1.1.05.jar ]; then
  cp lib/mod_cfml-valve_v1.1.05.jar /opt/lucee/current/
else
  curl --location -o /opt/lucee/current/mod_cfml-valve_v1.1.05.jar https://raw.githubusercontent.com/utdream/mod_cfml/master/java/mod_cfml-valve_v1.1.05.jar
fi

if [ ! -f /opt/lucee/modcfml-shared-key.txt ]; then
  echo "Generating Random Shared Secret..."
  openssl rand -base64 42 >> /opt/lucee/modcfml-shared-key.txt
  #clean out any base64 chars that might cause a problem
  sed -i "s/[\/\+=]//g" /opt/lucee/modcfml-shared-key.txt
fi

shared_secret=`cat /opt/lucee/modcfml-shared-key.txt`

sed -i "s/SHARED-KEY-HERE/$shared_secret/g" /etc/tomcat8/server.xml


echo "Setting Permissions on Lucee Folders"
mkdir /var/lib/tomcat8/lucee-server
chown -R tomcat8:tomcat8 /var/lib/tomcat8/lucee-server
chmod -R 750 /var/lib/tomcat8/lucee-server
chown -R tomcat8:tomcat8 /opt/lucee
chmod -R 750 /opt/lucee

echo "Setting JVM Max Heap Size to " $JVM_MAX_HEAP_SIZE

sed -i "s/-Xmx128m/-Xmx$JVM_MAX_HEAP_SIZE/g" /etc/default/tomcat8
