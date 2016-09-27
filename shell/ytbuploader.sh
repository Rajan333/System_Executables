#!/bin/bash

set -e

mkdir -p content

get_list()
{
    export PGPASSWORD=HornySardar && psql -h pp-content-new-db.cthkpx3mbvub.ap-southeast-1.rds.amazonaws.com -U root bauxite -c "select raw_content_id,name from content_copy where live = 'yes';" > brightcove_url_list.csv
cat brightcove_url_list.csv | sed 1,2d > brightcove_url_list.csv
}

youtube_upload()
{
    while read line
    do
        RAW_ID=`echo $line | awk '{print $1}'`
        NAME=`echo $line | awk '{ print substr($0, index($0,$3)) }'`
	echo $RAW_ID $NAME
        if [ "$RAW_ID" == " " ] || [ "$RAW_ID" == "|" ] || [ "$NAME" == " " ];then
            echo "Raw content id does not exist"
        else
            echo "Uploading $NAME"
            aws s3 cp s3://pp-brightcove-source/pp-raw-content-"$RAW_ID".mp4 content/pp-raw-content-"$RAW_ID".mp4
            YOUTUBE_ID=`youtube-upload --title="$NAME" content/pp-raw-content-"$RAW_ID".mp4`
            export PGPASSWORD=HornySardar && psql -h pp-content-new-db.cthkpx3mbvub.ap-southeast-1.rds.amazonaws.com -U root bauxite -c "update content_copy set youtube_id = '$YOUTUBE_ID' where raw_content_id = '$RAW_ID';"        
            rm -rf content/pp-raw-content-"$RAW_ID".mp4
            echo $RAW_ID $NAME "Updated..!!!" >> ytb.log
            sleep 1
        fi
    done<brightcove_url_list.csv
}       

get_list
youtube_upload
