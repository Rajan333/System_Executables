#!/bin/bash

set -e

RIMLESS_ENDPOINT="rimless.cthkpx3mbvub.ap-southeast-1.rds.amazonaws.com"
PPUSERPHONE_ENDPOINT="ppuserphone-meta-copy.cthkpx3mbvub.ap-southeast-1.rds.amazonaws.com" 

# DELETE ALREADY EXISTING TABLE
mysql -A -h $PPUSERPHONE_ENDPOINT -u root -pbul_42_cr8  -e "use uphonedata; drop table if exists user_apps_bkp;drop table if exists user_sms_bkp;"

# MIGRATING USER APPS DATA FROM RIMLESS TO PPUSERPHONE 
echo "Taking dump of user_apps"
mysqldump -h $RIMLESS_ENDPOINT -u root -pSomeshwarRocks pprim user_apps | sed -e 's/`user_apps`/`user_apps_bkp`/' | mysql -h $PPUSERPHONE_ENDPOINT -u root -pbul_42_cr8 uphonedata;

# MIGRATING USER SMS DATA FROM RIMLESS TO PPUSERPHONE
echo "Taking dump of user_sms"
mysqldump -h $RIMLESS_ENDPOINT -u root -pSomeshwarRocks pprim user_sms | sed -e 's/`user_sms`/`user_sms_bkp`/' | mysql -h $PPUSERPHONE_ENDPOINT -u root -pbul_42_cr8 uphonedata;

# RENAME BKP FILE TO ORIGINAL
echo "Renaming backup file to original..."
#mysql -A -h $PPUSERPHONE_ENDPOINT -u root -pbul_42_cr8  -e "use uphonedata; rename table user_apps to user_apps_test; rename table user_sms to user_sms_test; rename table user_apps_bkp to user_apps; rename table user_sms_bkp to user_sms;"

mysql -A -h $PPUSERPHONE_ENDPOINT -u root -pbul_42_cr8  -e "use uphonedata; drop table user_apps; drop table user_sms; rename table user_apps_bkp to user_apps; rename table user_sms_bkp to user_sms;"

#SEND COUNT MAIL TO THE USER 
APP_COUNT=`mysql -A -h $PPUSERPHONE_ENDPOINT -u root -pbul_42_cr8  -Bse "use uphonedata; select count(*) from user_apps;"`
SMS_COUNT=`mysql -A -h $PPUSERPHONE_ENDPOINT -u root -pbul_42_cr8  -Bse "use uphonedata; select count(*) from user_sms;"`

echo "Total apps:" $APP_COUNT "    " "Total sms:" $SMS_COUNT | mail -s "APPS and SMS count" rajan@pressplaytv.in,mayank@pressplaytv.in

echo "Mail Sent..!!!"
