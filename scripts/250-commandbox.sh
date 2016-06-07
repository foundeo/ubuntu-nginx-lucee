#!/bin/bash

echo "================= START 250-COMMANDBOX.SH ================="
echo " "
echo "BEGIN installing and configuring CommandBox ..."


echo "Install prerequisite JRE ..."
sudo apt-get install default-jre

echo "Add Ortus Solutions Key"
sudo gpg --keyserver keys.gnupg.net --recv-key 6DA70622
sudo gpg -a --export 6DA70622 | sudo apt-key add -
echo "deb http://downloads.ortussolutions.com/debs/noarch /" | sudo tee -a /etc/apt/sources.list.d/commandbox.list

echo "Install CommandBox ..."
sudo apt-get update && sudo apt-get install commandbox