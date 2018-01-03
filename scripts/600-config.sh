#!/bin/bash

#install commandbox
#note that you can also add commandbox to apt sources.list allowing you to update using apt-get
#
curl -o commandbox_3.9.2-1_all.deb https://downloads.ortussolutions.com/debs/noarch/commandbox_3.9.2-1_all.deb
COMMANDBOX_SHA256="0c8ae277e91390a180b43bc3f1f091754e1e83b2f552f06cc595591853bf9cac"

if [[ $(sha256sum commandbox_3.9.2-1_all.deb) =~ "$COMMANDBOX_SHA256" ]]; then
    echo "Verified commandbox SHA-256: $COMMANDBOX_SHA256"
else
    echo "SHA-256 Checksum of commandbox failed"
    exit 1
fi

dpkg -i commandbox_3.9.2-1_all.deb

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
service tomcat8 restart
