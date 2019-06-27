#!/bin/bash

jar_url="https://release.lucee.org/rest/update/provider/loader/$LUCEE_VERSION"
if [[ $LUCEE_LIGHT ]];then
    jar_url="https://release.lucee.org/rest/update/provider/light/$LUCEE_VERSION"
fi
jar_folder="lucee-$LUCEE_VERSION"

echo "Installing Lucee"
echo "Downloading Lucee " $LUCEE_VERSION
mkdir /opt/lucee
mkdir /opt/lucee/config
mkdir /opt/lucee/config/server
mkdir /opt/lucee/config/web
mkdir /opt/lucee/$jar_folder
curl --location -o /opt/lucee/$jar_folder/lucee.jar $jar_url

if [ -f "/opt/lucee/$jar_folder/lucee.jar" ]; then
  echo "Download Complete"
else
  echo "Download of Lucee Failed Exiting..."
  exit 1
fi

if [[ $LUCEE_JAR_SHA256 ]];then
    echo "Verifying SHA-256 checksum"
    if [[ $(sha256sum "/opt/lucee/$jar_folder/lucee.jar") =~ "$LUCEE_JAR_SHA256" ]]; then
        echo "Verified lucee.jar SHA-256: $LUCEE_JAR_SHA256"
    else
        echo "SHA-256 Checksum of lucee.jar verification failed"
        exit 1
    fi
fi

ln -s /opt/lucee/$jar_folder /opt/lucee/current
