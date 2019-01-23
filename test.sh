#!/bin/bash

chmod a+x /tmp/install.sh
cd /tmp/

#assume yes to all apt-get commands
echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/90assumeyes
export DEBIAN_FRONTEND=noninteractive

/tmp/install.sh

sleep 5

http_code=$(curl --verbose  -o /tmp/result.txt -w '%{http_code}' 'http://127.0.0.1:8080/lucee/admin/web.cfm';)
echo "Finished with Status: $http_code "
echo -e "\n-----\n"
#output the result
cat /tmp/result.txt

echo -e "\n-----\n"

if [ "$http_code" -ne 200 ]; then
	#fail if status code is not 200
    exit 1
fi
