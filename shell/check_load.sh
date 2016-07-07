#!/bin/bash 

set -e

COUNTER=0
while [  $COUNTER -lt 100000 ]; do
    curl -S api.pressplaytv.in/static/file.json
    let COUNTER=COUNTER+1 
done
