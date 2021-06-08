#!/bin/bash

#install commandbox
echo "Installing CommandBox"

curl -fsSl https://downloads.ortussolutions.com/debs/gpg | apt-key add -
echo "deb https://downloads.ortussolutions.com/debs/noarch /" | tee -a /etc/apt/sources.list.d/commandbox.list
apt-get update && apt-get install commandbox

box install commandbox-cfconfig

if [[ !$ADMIN_PASSWORD ]]; then
    echo "No ADMIN_PASSWORD set, generating a random password and storing it here: /root/lucee-admin-password.txt"
    touch /root/lucee-admin-password.txt
    chown root:root /root/lucee-admin-password.txt
    chmod 700 /root/lucee-admin-password.txt
    openssl rand -base64 64 | tr -d '\n\/\+=' > /root/lucee-admin-password.txt
    export ADMIN_PASSWORD=`cat /root/lucee-admin-password.txt`
fi

box cfconfig set adminPassword=$ADMIN_PASSWORD to=/opt/lucee/config/server/lucee-server/ toFormat=luceeServer@5
box cfconfig set adminPasswordDefault=$ADMIN_PASSWORD to=/opt/lucee/config/server/lucee-server/ toFormat=luceeServer@5

#restart to apply changes
service tomcat9 restart
