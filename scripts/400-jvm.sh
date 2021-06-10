#!/bin/bash


#No longer doing oracle jvm setup, using openjdk


echo "Tomcat / Lucee Configuration Done, Starting Tomcat"
echo `date`
service tomcat9 start

echo "Tomcat Status:"
systemctl --no-pager status tomcat9