#!/bin/bash
web_root="/web"

echo "Installing nginx"
apt-get install nginx
echo "Adding Railo nginx configuration files"
cp etc/nginx/conf.d/railo-global.conf /etc/nginx/conf.d/railo-global.conf
cp etc/nginx/railo.conf /etc/nginx/railo.conf
cp etc/nginx/railo-proxy.conf /etc/nginx/railo-proxy.conf

echo "Creating web root and default sites here: " $web_root
mkdir $web_root
mkdir $web_root/default
mkdir $web_root/default/wwwroot
mkdir $web_root/example.com
mkdir $web_root/example.com/wwwroot

echo "Creating a default index.html"
echo "<!doctype html><html><body><h1>Hello</h1></body></html>" > $web_root/default/wwwroot/index.html



#add tomcat7 to www-data group so it can read files
usermod -aG www-data tomcat7

#set the web directory permissions
chown -R root:www-data $web_root
chmod -R 750 $web_root


echo "Adding Default and Example Site to nginx"
cp etc/nginx/sites-available/*.conf /etc/nginx/sites-available/
echo "Removing nginx default site"
rm /etc/nginx/sites-enabled/default
echo "Adding our default site"
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

service nginx restart
