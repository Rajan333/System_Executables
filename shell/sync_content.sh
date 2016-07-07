#!/bin/bash 

set -e

mkdir -p brightcove-local

echo "Starting sync on '`date`'"
aws s3 sync s3://pp-brightcove-source/ brightcove-local/ 
echo "done..."
