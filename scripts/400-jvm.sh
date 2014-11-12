#!/bin/bash

echo "Installing Oracle JVM"
if [ -f $JVM_FILE ];
then
  mkdir /opt/railo/jvm
  tar -xf $JVM_FILE -C /opt/railo/jvm
  chown -R root:root /opt/railo/jvm
  chmod -R 755 /opt/railo/jvm
  ln -s /opt/railo/jvm/jdk$JVM_VERSION /opt/railo/jvm/current
  echo $'\nJAVA_HOME="/opt/railo/jvm/current"' >> /etc/default/tomcat7
else
  echo "File $JVM_FILE not found, SKIPPING Oracle JVM Installation"
fi

echo "Tomcat / Railo Configuration Done, Restarting Tomcat"
service tomcat7 restart
