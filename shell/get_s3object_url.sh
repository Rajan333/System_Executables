#!/bin/bash

set -e

BUCKET_NAME=$1
ZONE=`aws s3api get-bucket-location --bucket $BUCKET_NAME | grep LocationConstraint | awk '{print $2}' | tr -d '"'`
DEFAULT_URL="https://s3-$ZONE.amazonaws.com/"
#echo $ZONE
#echo $DEFAULT_URL

aws s3api list-objects --bucket pp-android-test-bucket --query 'Contents[].Key' | tr '[]",' ' ' | sed 1d | sed '$d'  > ~/link.txt

while read OBJECT
do
    #echo $OBJECT | tr ' ' '+'
    echo $DEFAULT_URL$BUCKET_NAME/$OBJECT | tr ' ' '+'
    sleep 1
done<~/link.txt
rm -rf ~/link.txt
