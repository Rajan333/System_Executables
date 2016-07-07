#!/bin/bash

set -e

DEV_SERVER="i-4a92c0ee"
TEST_SERVER="i-fb722c75"
AMMUNITION="i-19bbbfbd"
DATE=`date`
echo "Stopping servers on $DATE" > autostop_server.log 
echo "Stopping dev server" >> autostop_server.log
sudo aws ec2 stop-instances --instance-ids $DEV_SERVER 

echo "Stopping Test Server" >> autostop_server.log
aws ec2 stop-instances --instance-ids $TEST_SERVER

echo "Stopping Ammunition server" >> autostop_server.log
aws ec2 stop-instances --instance-ids $AMMUNITION
