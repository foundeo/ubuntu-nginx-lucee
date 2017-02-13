#!/bin/bash
web_root="/web"

echo "Installing nginx"
apt-get install nginx
echo "Adding lucee nginx configuration files"
cp etc/nginx/conf.d/lucee-global.conf /etc/nginx/conf.d/lucee-global.conf
cp etc/nginx/lucee.conf /etc/nginx/lucee.conf
cp etc/nginx/lucee-proxy.conf /etc/nginx/lucee-proxy.conf

echo "Configuring modcfml shared secret in nginx"
shared_secret=`cat /opt/lucee/modcfml-shared-key.txt`
sed -i "s/SHARED-KEY-HERE/$shared_secret/g" /etc/nginx/lucee-proxy.conf

echo "Creating web root and default sites here: " $web_root
mkdir $web_root
mkdir $web_root/default
mkdir $web_root/default/wwwroot
mkdir $web_root/example.com
mkdir $web_root/example.com/wwwroot

echo "Creating a default index.html"
echo "<!doctype html><html><body><h1>Hello</h1></body></html>" > $web_root/default/wwwroot/index.html



#add tomcat8 to www-data group so it can read files
usermod -aG www-data tomcat8

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
