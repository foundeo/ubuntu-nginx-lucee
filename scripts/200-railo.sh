#!/bin/bash

railo="http://www.getrailo.org/railo/remote/download42/$RAILO_VERSION/custom/all/railo-$RAILO_VERSION-jars.tar.gz"
railo_folder="railo-$RAILO_VERSION-jars"

echo "Installing Railo"
echo "Downloading Railo " $RAILO_VERSION
mkdir /opt/railo
mkdir /opt/railo/config
mkdir /opt/railo/config/server
mkdir /opt/railo/config/web
curl -o /opt/railo/railo.tar.gz $railo

if [ -f "/opt/railo/railo.tar.gz" ]; then
  echo "Download Complete"
else
  echo "Download of Railo Failed Exiting..."
  exit 1
fi

tar -xzf /opt/railo/railo.tar.gz -C /opt/railo
ln -s /opt/railo/$railo_folder /opt/railo/current
