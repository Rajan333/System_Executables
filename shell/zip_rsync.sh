#!/bin/bash

set -e

METAINFO=`curl http://pratush.dev.pressplaytv.in/util/box-version/latest`
ZIPLOCATION=`echo $METAINFO | jq -r '.zip_location'`

mkdir -p zipfolder

echo "rsync initiated" >> progress.log
echo "chal gya bc $ZIPLOCATION pe....." 
#rsync --progress -rave "ssh -i pratush.pem" pratush@54.255.151.235:$ZIPLOCATION/complete_content.zip zipfolder

echo "rsync completed" >> progress.log

