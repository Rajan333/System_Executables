#!/bin/bash

set -e

DATE=`date`

if [ ! -e /home/ubuntu/crons/update.lock ];then
    touch /home/ubuntu/crons/update.lock
    echo "Updation starts on $DATE" >> /home/ubuntu/crons/uphonedata.log 2>&1

    echo "Updating user_apps..." >> /home/ubuntu/crons/uphonedata.log 2>&1
    aws s3 sync /home/ubuntu/LOGS/user-apps/ s3://pp-uphonedata-backup/user_apps/ >> /home/ubuntu/crons/uphonedata_detail.log 2>&1
    echo "User apps updation Completed" >> /home/ubuntu/crons/uphonedata.log 2>&1

    echo "Updating user_sms..." >> /home/ubuntu/crons/uphonedata.log 2>&1
    aws s3 sync /home/ubuntu/LOGS/user-sms/ s3://pp-uphonedata-backup/user_sms/ >> /home/ubuntu/crons/uphonedata_detail.log 2>&1
    echo "User sms updation Completed" >> /home/ubuntu/crons/uphonedata.log 2>&1
    rm -rf /home/ubuntu/crons/update.lock
else
    echo "Update Lock Still Exists...Remove it First..!!!" >> /home/ubuntu/crons/uphonedata.log 2>&1
fi

echo "The Data for user apps and sms has been successfully updated" | mail -s "Data Updation" rajan@pressplaytv.in,mayank@pressplaytv.in

