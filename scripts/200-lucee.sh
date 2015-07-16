#!/bin/bash

jar_url="https://bitbucket.org/lucee/lucee/downloads/lucee-$LUCEE_VERSION-jars.zip"
jar_folder="lucee-$LUCEE_VERSION-jars"

echo "Installing Lucee"
echo "Downloading Lucee " $LUCEE_VERSION
mkdir $INSTALL_DIR
mkdir $INSTALL_DIR/config
mkdir $INSTALL_DIR/config/server
mkdir $INSTALL_DIR/config/web
curl -o $INSTALL_DIR/lucee.zip $jar_url

if [ -f "$INSTALL_DIR/lucee.zip" ]; then
  echo "Download Complete"
else
  echo "Download of Lucee Failed Exiting..."
  exit 1
fi

unzip $INSTALL_DIR/lucee.zip -d $INSTALL_DIR
ln -s $INSTALL_DIR/$jar_folder $INSTALL_DIR/current
