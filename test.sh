#!/bin/bash

cd "$(dirname "$0")"

chmod a+x ./install.sh


#assume yes to all apt-get commands
echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/90assumeyes
export DEBIAN_FRONTEND=noninteractive

./install.sh

if [[ $IN_DOCKER ]];then
    #systemd doesn't work in docker, so start manually
    export CATALINA_HOME=/usr/share/tomcat9
    export CATALINA_BASE=/var/lib/tomcat9
    export CATALINA_TMPDIR=/tmp
    export JAVA_OPTS=-Djava.awt.headless=true
    apt install sudo
    sudo --user=tomcat --preserve-env --set-home /usr/libexec/tomcat9/tomcat-start.sh &

fi

sleep 15

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

#test nginx setup
cp /etc/nginx/sites-available/example.com.conf /etc/nginx/sites-enabled/example.com.conf 
service nginx restart
echo "<cfheader statuscode='418' statustext='teapot'><cfoutput>Lucee #server.lucee.version#</cfoutput>" > /web/example.com/wwwroot/test.cfm 

#warmup hit
curl --verbose --resolve 'example.com:80:127.0.0.1' http://example.com/test.cfm

nginx_http_code=$(curl --verbose --resolve 'example.com:80:127.0.0.1'  -o /tmp/result.txt -w '%{nginx_http_code}'  'http://example.com/test.cfm';)
echo "Finished Nginx with Status: $nginx_http_code "
echo -e "\n-----\n"
#output the result
if [ -f "/tmp/result.txt" ]; then
  cat /tmp/result.txt
else
  echo "Nginx Result file did not exist"
  http_code=0
fi


echo -e "\n-----\n"


#output logs for debugging
cat /var/log/nginx/*.log 
cat /var/log/tomcat9/*.log

if [[ $DEBUG_SLEEP ]];then
    apt install vim
    echo "DEBUG SLEEPING: docker exec -it ID /bin/bash to debug container"
    echo "curl --verbose --resolve 'example.com:80:127.0.0.1' http://example.com/test.cfm"
    sleep 50000
fi

if [ "$http_code" -ne 200 ]; then

    #fail if status code is not 200
    exit 1
fi

if [ "$nginx_http_code" -ne 418 ]; then

    #fail if status code is not 418
    exit 1
fi
