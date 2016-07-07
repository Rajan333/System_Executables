#!/bin/bash

set -e


mkdir -p uncompressed compressed posters videos
#chown -R rajan:rajan .
aws s3 sync s3://pp-content-resources/ uncompressed/
mv uncompressed/*.png posters/
mv uncompressed/*.mp4 videos/


ls videos/ > videos.txt

while read line
do
    echo "$line"
    < /dev/null ffmpeg -i "videos/$line" -vcodec:v libx264 -profile:v baseline -level 3.0 -movflags +faststart -crf 23 -b:v 800k -codec:a aac -strict experimental -b:a 128k -video_size 1280x720 "compressed/$line"
    sudo aws s3 cp /mnt/compressed/"$line" s3://blender-target/"$line"
done<videos.txt


#sudo aws s3 cp /mnt/posters/* s3://blender-source/

#sudo rm -rf /mnt/videos.txt /mnt/uncompressed /mnt/compressed /mnt/posters /mnt/videos

echo "Done...!!!"



