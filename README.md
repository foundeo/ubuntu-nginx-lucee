ubuntu-nginx-railo
==================

Script for standing up a Railo server using nginx and Tomcat on Ubuntu. Uses the
Tomcat from the Ubuntu distribution so you can update Tomcat using `apt-get update tomcat7`

What does it do?
----------------

1. **Updates Ubuntu** - simply runs `apt-get update` and `apt-get upgrade`
2. **Downloads Railo** - uses curl to download railo jars from getrailo.org places railo jars in `/opt/railo/current/`
3. **Installs & Configures Tomcat 7** - runs `apt-get install tomcat7` updates the `web.xml` `server.xml` and `catalina.properties` to configure Railo servlets and mod_cfml Valve.
4. **Installs Oracle JVM** - if you downloaded a server-jre and specified its path in the config it will extract it under `/opt/railo/jvm/version` and then create a symbolic link `/opt/railo/jvm/current` to denote the current jvm version to use. It also edits tomcat config to point to this jvm.
5. **Installs & Configures nginx** - runs `apt-get install nginx` to install nginx. Crates a web root directory. Creates a `railo.config` file so you can just `include railo.config` for any site that uses CFML

Take a look in the `scripts/` subfolder to see the script for each step.

How do I run it?
----------------

1. **Download Oracle JVM** - Vist [java.oracle.com](http://java.oracle.com/) to download the latest server-jre
2. **Downlaod this repository** - `curl -Lo /root/ubuntu-nginx-railo.tar.gz https://api.github.com/repos/foundeo/ubuntu-nginx-railo/tarball/master`
3. **Extract repository** - `tar -xzvf /root/ubuntu-nginx-railo.tar.gz`
4. **Edit the `install.sh`** - Change any configuration options such as the Railo Version or JVM version.
5. **Copy jvm** - make sure the jvm you downloaded from oracle is located in the folder that contains install.sh, eg `/root/foundeo-ubuntu-nginx-railo-abcdefg/`
6. **Run install.sh** - make sure you are root or sudo and run `./install.sh` you may need to `chmod u+x install.sh` to give execute permissions to the script.
7. **Set Railo Passwords** - login to `/railo-context/admin/server.cfm` and set the server password, and also set the default web context password.

Limitations / Known Issues
--------------------------

* The servlet definitions and mappings (located in `/etc/tomcat7/web.xml`) are slimmed down, so if you need things like REST web services, flash/flex remoting support see the [Railo docs for web.xml config](https://github.com/getrailo/railo/wiki/Configuration:web.xml)
* The `/railo-context/` uri is blocked in `/etc/nginx/railo.conf` you must add in your ip address and restart nginx.
* There is no uninstall option
* This script has been tested on Ubuntu 14.04 LTS only

Thanks go to [Booking Boss](http://www.bookingboss.com/) for funding the initial work on this script.
