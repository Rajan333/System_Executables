#!/bin/bash
set -e

LOOPIN_VERSION=$2
CONTENT_VERSION=`echo $(jq -r '.content_version' /mnt/box_content/json/loopin.json)`

if [ $LOOPIN_VERSION == $CONTENT_VERSION ];
then

LOOPIN_DOWNLOAD=`echo $(jq -r '.DOWNLOADS_DIR' $BOX_JSON)temp`

URL=$1
wget --continue -O $LOOPIN_DOWNLOAD/temp-loopin.json  $URL

LOOPIN_LOCATION=`echo $(jq -r '.MEDIACARD_PLUG_MOUNT_POINT' $BOX_JSON)/json/`

sudo mv $LOOPIN_DOWNLOAD/temp-loopin.json $LOOPIN_LOCATION/loopin.json

else

echo "Not a target version..."

fi
