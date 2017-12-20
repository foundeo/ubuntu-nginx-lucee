#!/bin/bash

#download commandbox to run cfconfig
#having issue with this binary
#curl --location -o /opt/lucee/box https://www.ortussolutions.com/parent/download/commandbox/type/linux-jre64
curl --location -o /opt/lucee/box https://raw.githubusercontent.com/foundeo/cfmatrix/master/bin/box

chmod a+x /opt/lucee/box

/opt/lucee/box install commandbox-cfconfig

if [[ !$ADMIN_PASSWORD ]]; then
    echo "No ADMIN_PASSWORD set, generating a random password and storing it here: /root/lucee-admin-password.txt"
    touch /root/lucee-admin-password.txt
    chown root:root /root/lucee-admin-password.txt
    chmod 700 /root/lucee-admin-password.txt
    openssl rand -base64 64 | tr -d '\n\/\+=' > /root/lucee-admin-password.txt
    export ADMIN_PASSWORD=`cat /root/lucee-admin-password.txt`
fi

/opt/lucee/box cfconfig set adminPassword=$ADMIN_PASSWORD to=/opt/lucee/config/server/lucee-server/ toFormat=luceeServer@5
/opt/lucee/box cfconfig set adminPasswordDefault=$ADMIN_PASSWORD to=/opt/lucee/config/server/lucee-server/ toFormat=luceeServer@5

#restart to apply changes
service tomcat8 restart
