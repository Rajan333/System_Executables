#!/bin/bash

set -e

RAW_ID=`aws s3 ls s3://pp-vid-testing | awk '{print $4}' | tr '-' ' ' | tr '.' ' ' | awk '{print $4}'`
#echo "raw content id " $RAW_ID

GIVEN_ID=`cat ~/system_scripts/rajan.txt`
#echo "given id" $GIVEN_ID

for item1 in ${GIVEN_ID[@]}
do
    for item2 in ${RAW_ID[@]}
    do
        if [[ $item2 == $item1 ]];
        then
            intersection=$item1
            echo $intersection",""brightcove_id"
           # pyhton brightcove-inges-working.py
           # bash rename_csv.sh
            break
        fi
    done
done
