#!/bin/bash

cd "$(dirname "$0")"

chmod a+x ./install.sh


#assume yes to all apt-get commands
echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/90assumeyes
export DEBIAN_FRONTEND=noninteractive

./install.sh

sleep 5

if [[ $IN_DOCKER ]];then
    #systemd doesn't work in docker, so start manually
    export CATALINA_HOME=/usr/share/tomcat9
    export CATALINA_BASE=/var/lib/tomcat9
    export CATALINA_TMPDIR=/tmp
    export JAVA_OPTS=-Djava.awt.headless=true
    sudo -u tomcat cd $CATALINA_HOME ; /usr/libexec/tomcat9/tomcat-start.sh &
fi

http_code=$(curl --verbose  -o /tmp/result.txt -w '%{http_code}' 'http://127.0.0.1:8080/lucee/admin/web.cfm';)
echo "Finished with Status: $http_code "
echo -e "\n-----\n"
#output the result
if [ -f "/tmp/result.txt" ]; then
  cat /tmp/result.txt
else
  echo "Result file did not exist"
  http_code=0
fi


echo -e "\n-----\n"

#output logs for debugging
cat /var/log/nginx/*.log 
cat /var/log/tomcat9/*.log

if [[ $DEBUG_SLEEP ]];then
    sleep 50000
fi

if [ "$http_code" -ne 200 ]; then
	

    #fail if status code is not 200
    exit 1
fi
