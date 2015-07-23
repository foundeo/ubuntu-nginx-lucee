#!/bin/bash

jar_url="https://bitbucket.org/lucee/lucee/downloads/lucee-$LUCEE_VERSION-jars.zip"
jar_folder="lucee-$LUCEE_VERSION"

echo "Installing Lucee"
echo "Downloading Lucee " $LUCEE_VERSION
mkdir /opt/lucee
mkdir /opt/lucee/config
mkdir /opt/lucee/config/server
mkdir /opt/lucee/config/web
mkdir /opt/lucee/$jar_folder
curl -L -k -o /opt/lucee/lucee.zip $jar_url

if [ -f "/opt/lucee/lucee.zip" ]; then
  echo "Download Complete"
else
  echo "Download of Lucee Failed Exiting..."
  exit 1
fi

unzip /opt/lucee/lucee.zip -d /opt/lucee/$jar_folder
ln -s /opt/lucee/$jar_folder /opt/lucee/current
