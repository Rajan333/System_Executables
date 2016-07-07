#!/bin/bash

set -e

mkdir -p images

sudo aws s3 sync s3://pp-content-resources/ images/

ls images > images.txt

while read line
do
    echo $line
    sleep 1
done<images.txt

