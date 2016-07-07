#!/bin/bash

set -e

RAW_ID=$1
echo $RAW_ID
CONTENT_ID=`aws s3 ls s3://pp-brightcove-source/pp-raw-content-$RAW_ID.mp4 | awk '{print $4}'`
echo "Downloading... $CONTENT_ID"
aws s3 cp s3://pp-brightcove-source/pp-raw-content-$RAW_ID.mp4 . 
echo "Downloaded...!!!"

