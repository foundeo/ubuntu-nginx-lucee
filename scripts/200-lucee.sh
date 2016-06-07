#!/bin/bash

echo "================= START 200-LUCEE.SH ================="
echo " "
echo "BEGIN installing and configuring Lucee ..."

if [ ! -d "/opt/lucee" ]; then

	echo "... Downloading the Lucee installer, standby ..."
	wget -O ~/lucee.run $LUCEE_INSTALLER
	
	sudo chmod +x ~/lucee.run
	echo "... Installing Lucee ..."
	sudo ~/lucee.run --mode unattended --luceepass pil0t0 --bittype 64 --installiis no --installconn no --installmodcfml yes --systemuser deploy
fi

echo "... Copying the Lucee config files into place ..."
sudo mv /opt/lucee/tomcat/bin/setenv.sh /opt/lucee/tomcat/bin/setenv.sh.pkg
sudo cp etc/lucee/setenv.sh /opt/lucee/tomcat/bin
sudo cp etc/lucee/lucee-server.xml /opt/lucee/tomcat/lucee-server/context

#backup default server.xml
cp /opt/lucee/tomcat/conf/server.xml /opt/lucee/tomcat/conf/server.xml-orig-backup
#copy our server.xml to tomcat dir
cp etc/lucee/server.xml /opt/lucee/tomcat/conf

sudo chown deploy:deploy /opt/lucee/tomcat/conf/server.xml

echo "... Installing MongoDB Extension ..."
sudo cp -R etc/lucee/mongodb-extension-modern/* /opt/lucee/tomcat/lucee-server/deploy/

if [ ! -f /opt/lucee/modcfml-shared-key.txt ]; then
  echo "Generating Random Shared Secret..."
  openssl rand -base64 42 >> /opt/lucee/modcfml-shared-key.txt
  #clean out any base64 chars that might cause a problem
  sed -i "s/[\/\+=]//g" /opt/lucee/modcfml-shared-key.txt
fi

shared_secret=`cat /opt/lucee/modcfml-shared-key.txt`

sed -i "s/SHARED-KEY-HERE/$shared_secret/g" /opt/lucee/tomcat/conf/server.xml

# echo "Setting Permissions on Lucee Folders"
# chown -R deploy:deploy /opt/lucee
# chmod -R 750 /opt/lucee
echo "... Restarting Lucee ..."
sudo service lucee_ctl restart > /dev/null