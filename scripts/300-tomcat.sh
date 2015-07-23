#!/bin/bash

echo "Installing Tomcat 7"
apt-get install tomcat7

echo "Configuring Tomcat"

mkdir backup
mkdir backup/etc
mkdir backup/etc/tomcat7
mkdir backup/etc/default
#backup default tomcat web.xml
cp /etc/tomcat7/web.xml backup/etc/tomcat7/web.xml-orig-backup
#copy our web.xml to tomcat directory
cp etc/tomcat7/web.xml /etc/tomcat7/

#backup default server.xml
cp /etc/tomcat7/server.xml backup/etc/tomcat7/server.xml-orig-backup
#copy our server.xml to tomcat dir
cp etc/tomcat7/server.xml /etc/tomcat7/

#backup default catalina.properties
cp /etc/tomcat7/catalina.properties backup/etc/tomcat7/catalina.properties-orig-backup
#copy our catalina properties
cp etc/tomcat7/catalina.properties /etc/tomcat7/

cp /etc/default/tomcat7 backup/etc/default/tomcat7

echo "Installing Lucee Java Agent into Tomcat"
echo $'\nJAVA_OPTS="${JAVA_OPTS} -javaagent:/opt/lucee/current/lucee-inst.jar"' > /etc/default/tomcat7

echo "Installing mod_cfml Valve for Automatic Virtual Host Configuration"
if [ -f lib/mod_cfml-valve_v1.1.04.jar ]; then
  cp lib/mod_cfml-valve_v1.1.04.jar /opt/lucee/current/
else
  curl --location -o /opt/lucee/current/mod_cfml-valve_v1.1.04.jar https://raw.githubusercontent.com/utdream/mod_cfml/master/java/mod_cfml-valve_v1.1.04.jar
fi

if [ ! -f /opt/lucee/modcfml-shared-key.txt ]; then
  echo "Generating Random Shared Secret..."
  openssl rand -base64 42 >> /opt/lucee/modcfml-shared-key.txt
  #clean out any base64 chars that might cause a problem
  sed -i "s/[\/\+=]//g" /opt/lucee/modcfml-shared-key.txt
fi

shared_secret=`cat /opt/lucee/modcfml-shared-key.txt`

sed -i "s/SHARED-KEY-HERE/$shared_secret/g" /etc/tomcat7/server.xml

echo "Setting Permissions on Lucee Folders"
chown -R tomcat7:tomcat7 /opt/lucee
chmod -R 750 /opt/lucee

echo "Setting JVM Max Heap Size to " $JVM_MAX_HEAP_SIZE

sed -i "s/-Xmx128m/-Xmx$JVM_MAX_HEAP_SIZE/g" /etc/default/tomcat7
