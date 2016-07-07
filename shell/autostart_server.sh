#!/bin/bash

set -e

DEV_SERVER="i-4a92c0ee"
TEST_SERVER="i-fb722c75"
AMMUNITION="i-19bbbfbd"
DATE=`date`
echo "Starting servers on $DATE" > autostart_server.log 
echo "Starting dev server" >> autostart_server.log
sudo aws ec2 start-instances --instance-ids $DEV_SERVER 

echo "Starting Test Server" >> autostart_server.log
sudo aws ec2 start-instances --instance-ids $TEST_SERVER

echo "Starting Ammunition server" >> autostart_server.log
sudo aws ec2 start-instances --instance-ids $AMMUNITION
