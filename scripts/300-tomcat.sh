#!/bin/bash

echo "Installing Tomcat 7"
apt-get install tomcat7

echo "Configuring Tomcat"
#backup default tomcat web.xml
cp /etc/tomcat7/web.xml /etc/tomcat7/web.xml-orig-backup
#copy our web.xml to tomcat directory
cp etc/tomcat7/web.xml /etc/tomcat7/

#backup default server.xml
cp /etc/tomcat7/server.xml /etc/tomcat7/server.xml-orig-backup
#copy our server.xml to tomcat dir
cp etc/tomcat7/server.xml /etc/tomcat7/

#backup default catalina.properties
cp /etc/tomcat7/catalina.properties /etc/tomcat7/catalina.properties-orig-backup
#copy our catalina properties
cp etc/tomcat7/catalina.properties /etc/tomcat7/

echo "Installing Railo Java Agent into Tomcat"
echo $'\nJAVA_OPTS="${JAVA_OPTS} -javaagent:/opt/railo/current/railo-inst.jar"' >> /etc/default/tomcat7

echo "Setting Permissions on Railo Folders"
chown -R tomcat7:tomcat7 /opt/railo
chmod -R 750 /opt/railo

echo "Setting JVM Max Heap Size to " $JVM_MAX_HEAP_SIZE
sed -e 's/-Xmx128m/-Xmx$JVM_MAX_HEAP_SIZE/g' /etc/default/tomcat7 >> /etc/default/tomcat7

echo "Installing mod_cfml Valve for Automatic Virtual Host Configuration"
curl -o /opt/railo/current/mod_cfml-valve_v1.0.14.jar http://download.modcfml.org/downloader.cfm/id/24/file/mod_cfml-valve_v1.0.14.jar
