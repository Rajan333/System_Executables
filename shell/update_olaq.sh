#!/bin/sh

#set -e

software_version=`echo_version`
if [ $software_version == "0.9.9olaq" ]; then
	timeout 5m wget -O /home/pi/downloads/temp/olaq/olaq.zip api-2.pressplaytv.in/static/utilities/resources/olaq.zip && sudo unzip -o /home/pi/downloads/temp/olaq/olaq.zip -d /home/pi/downloads/temp/olaq && sudo unzip -o /home/pi/downloads/temp/olaq/olaq.zip -d /home/pi/ && sudo mv /home/pi/downloads/temp/olaq/dnsmasq.conf /etc/ && sudo mv /home/pi/downloads/temp/olaq/internet_setup.sh /usr/local/bin/ 

fi    
