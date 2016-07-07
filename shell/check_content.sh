#!/bin/bash

set -e

# Command line input of a file containing list of all files with absolute path to check 
FILE=$1

# Iterating List of a file one by one
while read file
do
    # Check if a file exists or not
    if [ ! -e "$file" ];
    then
        echo $file "does not exist"
    fi
     sleep 1

done<$FILE


