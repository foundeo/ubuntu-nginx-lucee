#!/bin/bash

LUCEE_VERSION="5.1.1.65"

jar_url="http://cdn.lucee.org/rest/update/provider/loader/$LUCEE_VERSION"
jar_folder="lucee-$LUCEE_VERSION"

if [ -f "/opt/lucee/$jar_folder/lucee.jar" ]; then
  echo "The folder /opt/lucee/$jar_folder already exists. Exiting..."
  exit 1
fi


echo "Installing Lucee"
echo "Downloading Lucee " $LUCEE_VERSION

mkdir /opt/lucee/$jar_folder
curl --location -o /opt/lucee/lucee.zip $jar_url


unzip /opt/lucee/lucee.zip -d /opt/lucee/$jar_folder

if [ -f "/opt/lucee/$jar_folder/lucee.jar" ]; then
  echo "Download Complete"
else
  echo "Download of Lucee Failed Exiting..."
  exit 1
fi

echo "Installing mod_cfml Valve for Automatic Virtual Host Configuration"
if [ -f /opt/lucee/current/mod_cfml-valve_v1.1.05.jar ]; then
  cp /opt/lucee/current/mod_cfml-valve_v1.1.05.jar /opt/lucee/$jar_folder
else
  curl --location -o /opt/lucee/$jar_folder/mod_cfml-valve_v1.1.05.jar https://raw.githubusercontent.com/utdream/mod_cfml/master/java/mod_cfml-valve_v1.1.05.jar
fi

ln -s /opt/lucee/$jar_folder /opt/lucee/current

echo "Setting Permissions on Lucee Folders"
chown -R tomcat8:tomcat8 /opt/lucee
chmod -R 750 /opt/lucee
