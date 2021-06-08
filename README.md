ubuntu-nginx-lucee
==================

[![Build Status](https://travis-ci.org/foundeo/ubuntu-nginx-lucee.svg?branch=master)](https://travis-ci.org/foundeo/ubuntu-nginx-lucee)

A set of bash scripts for standing up a Lucee server using nginx and Tomcat on Ubuntu. Uses the
Tomcat from the Ubuntu distribution so you can update Tomcat using `apt-get update tomcat8`

*Important:* The master branch is now using Lucee 5, for Lucee 4.5 see the [lucee45-ubuntu14](https://github.com/foundeo/ubuntu-nginx-lucee/tree/lucee45-ubuntu14) branch.

Why would I use this instead of the offical Lucee installers?
-------------------------------------------------------------

* You want to run nginx as your web server
* You want to update Tomcat via `apt-get`

What does it do?
----------------

1. **Updates Ubuntu** - simply runs `apt-get update` and `apt-get upgrade`
2. **Downloads Lucee** - uses curl to download lucee jars from BitBucket places jars in `/opt/lucee/current/`
3. **Installs & Configures Tomcat 8** - runs `apt-get install tomcat8` updates the `web.xml` `server.xml` and `catalina.properties` to configure Lucee servlets and mod_cfml Valve.  (Tomcat/Lucee run on port 8080 by default).
4. **JVM** - in previous versions this step installed an Oracle JVM, but now we just use OpenJDK.
5. **Installs & Configures nginx** - runs `apt-get install nginx` to install nginx. Crates a web root directory. Creates a `lucee.config` file so you can just `include lucee.config` for any site that uses CFML
6. **Set Default Lucee Admin Password** - uses cfconfig to set the Lucee server context password and default web context password. If environment variable ADMIN_PASSWORD exists that is used, otherwise a random password is set.  

Take a look in the `scripts/` subfolder to see the script for each step.

How do I run it?
----------------

1. **Downlaod this repository** - `curl -Lo /root/ubuntu-nginx-lucee.tar.gz https://api.github.com/repos/foundeo/ubuntu-nginx-lucee/tarball/master`
2. **Extract repository** - `tar -xzvf /root/ubuntu-nginx-lucee.tar.gz`
3. **Configuration** - You can either Edit the `install.sh` and change any configuration options such as the Lucee Version or JVM version - or you can use environment variables (see below).
4. **Run install.sh** - make sure you are root or sudo and run `./install.sh` you may need to `chmod u+x install.sh` to give execute permissions to the script.


Limitations / Known Issues
--------------------------

* The servlet definitions and mappings (located in `/etc/tomcat8/web.xml`) are slimmed down, so if you need things like REST web services, flash/flex remoting support see the [Railo docs for web.xml config](https://github.com/getrailo/railo/wiki/Configuration:web.xml)
* The `/lucee/` uri is blocked in `/etc/nginx/lucee.conf` you must add in your ip address and restart nginx.
* There is no uninstall option
* This version of the script has been tested on Ubuntu 20.04 LTS only

Environment Variables
--------------------------

The script can be configured with the following environment variables:

* `LUCEE_VERSION` - sets the version of Lucee that it will attempt to install (eg 5.2.4.37).
* `JVM_MAX_HEAP_SIZE` - sets the amount of memory that java / tomcat can use (eg 512m).
* `ADMIN_PASSWORD` - sets the Lucee server context password and default web context password. If variable is not defined a random password is generated and set.
* `WHITELIST_IP` - if specified this IP will be whitelisted to allow access to /lucee/
* `LUCEE_JAR_SHA256` - if specified checks the sha256sum of the the downloaded lucee.jar

Setting up a Virtual Host
-------------------------

By default nginx on Ubuntu looks in the folder `/etc/nginx/sites-enabled/` for configuration nginx files. To setup a site create a file in that folder (another technique you can use is to create the file in `/etc/nginx/sites-available/` and then create a symbolic link in sites-enabled to enable the site), for example `/etc/nginx/sites-enabled/me.example.com.conf` at a minimum it will look like this:

	server {
		listen 80;
		server_name me.example.com;
		root /web/me.example.com/wwwroot/;
		include lucee.conf;
	}

You may also want to break logging for this site out into its own file, like this:

	server {
		listen 80;
		server_name me.example.com;
		root /web/me.example.com/wwwroot/;
		access_log /var/log/nginx/me.example.com.access.log;
		error_log /var/log/nginx/me.example.com.error.log;
		include lucee.conf;
	}

If you don't need Lucee/CFML for a given site, simply omit the `include lucee.conf;` line, like this:

	server {
		listen 80;
		server_name img.example.com;
		root /web/img.example.com/wwwroot/;
	}

Create the symbolic link in sites-enabled to enable the site:

	sudo ln -s /etc/nginx/sites-available/me.example.com.conf /etc/nginx/sites-enabled/

After making changes you need to restart or reload nginx:

	sudo service nginx restart

For more information on configuring nginx see the [nginx Wiki](http://wiki.nginx.org/Configuration)


Thanks go to [Booking Boss](http://www.bookingboss.com/) for funding the initial work on this script.
