#!/bin/bash


#No longer doing oracle jvm setup

echo "Tomcat / Lucee Configuration Done, Restarting Tomcat"
service tomcat9 restart

echo "Tomcat Status:"
service tomcat9 status