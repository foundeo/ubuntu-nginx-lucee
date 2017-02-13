#!/bin/bash

echo "Installing Oracle JVM"
if [ -f $JVM_FILE ];
then
  mkdir /opt/lucee/jvm
  tar -xf $JVM_FILE -C /opt/lucee/jvm
  chown -R root:root /opt/lucee/jvm
  chmod -R 755 /opt/lucee/jvm
  ln -s /opt/lucee/jvm/jdk$JVM_VERSION /opt/lucee/jvm/current
  echo $'\nJAVA_HOME="/opt/lucee/jvm/current"' >> /etc/default/tomcat8
else
  echo "File $JVM_FILE not found, SKIPPING Oracle JVM Installation"
fi

echo "Tomcat / Lucee Configuration Done, Restarting Tomcat"
service tomcat8 restart
