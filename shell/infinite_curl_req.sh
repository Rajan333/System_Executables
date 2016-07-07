#!/bin/bash

URL="api.pressplaytv.in/v1/init"

while :
do
    curl -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data '{"user_details":{"first_name":"","middle_name":"","last_name":"","email":"","phone":"","dob":"","gender":"","city":"","region":"","country":"","zip":"","facebook_user_name":"","facebook_user_id":"","google_user_name":"","google_user_id":"","interests":""},"device_details":{"type":"mobile","model":"XTT203","manufacturer":"Samsung","os_version":"2.3.7","height":"1999","mac_addr":"","imei":"","hardware_id":"","width":"290","source":"Android","software_version":"0.9.8"}}' $URL
done
