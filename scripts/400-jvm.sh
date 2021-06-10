#!/bin/bash


#No longer doing oracle jvm setup, using openjdk


echo "Tomcat / Lucee Configuration Done, Restarting Tomcat"
service tomcat9 restart

echo "Tomcat Status:"
systemctl --no-pager status tomcat9