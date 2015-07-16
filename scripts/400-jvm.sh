#!/bin/bash

echo "Installing Oracle JVM"
if [ -f $JVM_FILE ];
then
  mkdir $INSTALL_DIR/jvm
  tar -xf $JVM_FILE -C $INSTALL_DIR/jvm
  chown -R root:root $INSTALL_DIR/jvm
  chmod -R 755 $INSTALL_DIR/jvm
  ln -s $INSTALL_DIR/jvm/jdk$JVM_VERSION $INSTALL_DIR/jvm/current
  echo $'\nJAVA_HOME="$INSTALL_DIR/jvm/current"' >> /etc/default/tomcat7
else
  echo "File $JVM_FILE not found, SKIPPING Oracle JVM Installation"
fi

echo "Tomcat / Lucee Configuration Done, Restarting Tomcat"
service tomcat7 restart
