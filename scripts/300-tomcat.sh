#!/bin/bash

echo "Installing Tomcat 9"
apt-get install tomcat9 openjdk-11-jdk-headless

echo "Stopping Tomcat"
echo `date`
service tomcat9 stop


echo "Configuring Tomcat"

mkdir backup
mkdir backup/etc
mkdir backup/etc/tomcat9
mkdir backup/etc/default
#backup default tomcat web.xml
cp /etc/tomcat9/web.xml backup/etc/tomcat9/web.xml-orig-backup
#copy our web.xml to tomcat directory
cp etc/tomcat9/web.xml /etc/tomcat9/

#backup default server.xml
cp /etc/tomcat9/server.xml backup/etc/tomcat9/server.xml-orig-backup
#copy our server.xml to tomcat dir
cp etc/tomcat9/server.xml /etc/tomcat9/

#backup default catalina.properties
cp /etc/tomcat9/catalina.properties backup/etc/tomcat9/catalina.properties-orig-backup
#copy our catalina properties
cp etc/tomcat9/catalina.properties /etc/tomcat9/

cp /etc/default/tomcat9 backup/etc/default/tomcat9

echo "Installing mod_cfml Valve for Automatic Virtual Host Configuration"
if [ -f lib/mod_cfml-valve_v1.1.05.jar ]; then
  cp lib/mod_cfml-valve_v1.1.05.jar /opt/lucee/current/
else
  curl --location -o /opt/lucee/current/mod_cfml-valve_v1.1.05.jar https://raw.githubusercontent.com/utdream/mod_cfml/master/java/mod_cfml-valve_v1.1.05.jar
fi

MODCFML_JAR_SHA256="22c769ccead700006d53052707370c5361aabb9096473f92599708e614dad638"
if [[ $(sha256sum "/opt/lucee/current/mod_cfml-valve_v1.1.05.jar") =~ "$MODCFML_JAR_SHA256" ]]; then
    echo "Verified mod_cfml-valve_v1.1.05.jar SHA-256: $MODCFML_JAR_SHA256"
else
    echo "SHA-256 Checksum of mod_cfml-valve_v1.1.05.jar verification failed"
    exit 1
fi

if [ ! -f /opt/lucee/modcfml-shared-key.txt ]; then
  echo "Generating Random Shared Secret..."
  openssl rand -base64 42 >> /opt/lucee/modcfml-shared-key.txt
  #clean out any base64 chars that might cause a problem
  sed -i "s/[\/\+=]//g" /opt/lucee/modcfml-shared-key.txt
fi

shared_secret=`cat /opt/lucee/modcfml-shared-key.txt`

sed -i "s/SHARED-KEY-HERE/$shared_secret/g" /etc/tomcat9/server.xml


echo "Setting Permissions on Lucee Folders"
mkdir /var/lib/tomcat9/lucee-server
chown -R tomcat:tomcat /var/lib/tomcat9/lucee-server
chmod -R 750 /var/lib/tomcat9/lucee-server
chown -R tomcat:tomcat /opt/lucee
chmod -R 750 /opt/lucee

echo "Setting JVM Max Heap Size to " $JVM_MAX_HEAP_SIZE

#sed -i "s/-Xmx128m/-Xmx$JVM_MAX_HEAP_SIZE/g" /etc/default/tomcat9
#-Dlucee.base.dir=/opt/lucee/config/server/
echo "JAVA_OPTS=\"\${JAVA_OPTS} -Xmx$JVM_MAX_HEAP_SIZE -Dlucee.base.dir=/opt/lucee/config/server/\"" >> /etc/default/tomcat9

echo "LUCEE_SERVER_DIR=\"/opt/lucee/config/server/\"" >> /etc/default/tomcat9
echo "LUCEE_BASE_DIR=\"/opt/lucee/config/server/\"" >> /etc/default/tomcat9

#In Ubuntu 20.04 necessary because ReadWritePaths is defined
if [ ! -d "/etc/systemd/system/tomcat9.service.d" ] ; then 
  mkdir /etc/systemd/system/tomcat9.service.d/
fi
echo "[Service]" > /etc/systemd/system/tomcat9.service.d/lucee.conf
echo "ReadWritePaths=/opt/lucee/" >> /etc/systemd/system/tomcat9.service.d/lucee.conf

systemctl daemon-reload && sleep 5
