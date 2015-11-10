#!/bin/bash

LUCEE_VERSION="4.5.2.018"

jar_url="https://bitbucket.org/lucee/lucee/downloads/lucee-$LUCEE_VERSION-jars.zip"
jar_folder="lucee-$LUCEE_VERSION"

echo "Installing Lucee"
echo "Downloading Lucee " $LUCEE_VERSION

mkdir /opt/lucee/$jar_folder
curl --location -o /opt/lucee/lucee.zip $jar_url

if [ -f "/opt/lucee/lucee.zip" ]; then
  echo "Download Complete"
else
  echo "Download of Lucee Failed Exiting..."
  exit 1
fi

unzip /opt/lucee/lucee.zip -d /opt/lucee/$jar_folder
ln -s /opt/lucee/$jar_folder /opt/lucee/current

echo "Installing mod_cfml Valve for Automatic Virtual Host Configuration"
if [ -f lib/mod_cfml-valve_v1.1.05.jar ]; then
  cp lib/mod_cfml-valve_v1.1.05.jar /opt/lucee/current/
else
  curl --location -o /opt/lucee/current/mod_cfml-valve_v1.1.05.jar https://raw.githubusercontent.com/utdream/mod_cfml/master/java/mod_cfml-valve_v1.1.05.jar
fi

echo "Setting Permissions on Lucee Folders"
chown -R tomcat7:tomcat7 /opt/lucee
chmod -R 750 /opt/lucee
