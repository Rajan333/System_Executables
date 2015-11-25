#!/bin/bash

set -e
VERSION=`echo_version`

if [ $VERSION == "0.9.9olan" ];then

    sudo mkdir -p downloads/temp && sudo wget -O downloads/temp/find  api-2.pressplaytv.in/static/utilities/resources/box_binaries/find && sudo mv downloads/temp/find /usr/bin/ && echo "binary updated..."
 
fi
    
