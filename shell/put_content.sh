#!/bin/bash

set -e

JSON_FILE=$1

CONTENT_LIST=`echo $(jq -r '.content' $JSON_FILE)`
echo $CONTENT_LIST

exit
CONTENT_LIST="pp-content-1594"

for CONTENT_ID in $CONTENT_LIST
do
    CONTENT=`aws s3 ls s3://pp-brightcove-source/ | grep $CONTENT_ID`
    DOWNLOAD_ID=`echo $CONTENT | awk '{print $4}'`
    echo $DOWNLOAD_ID
    #ssh smithy "aws s3 cp s3://pp-brightcove-source/$DOWNLOAD_ID "destination_folder""
     
done
