#!/bin/bash

set -e

CONTENT_ID=$1

curl ammunition.pressplaytv.in/content/fetch/$CONTENT_ID > get_content.json 
clear

echo "RAW CONTENT ID...."
echo $(jq -r '.data.raw_content_id' get_content.json)
