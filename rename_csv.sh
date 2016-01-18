#!/bin/bash

set -e

CSV_FILE=$1

for line in `cat $CSV_FILE`
do
    ORIGINAL=`echo ${line//,/ } | awk '{print $1}' | tr '\r' ' '`
    RENAMED=`echo ${line//,/ } | awk '{print $2}' | tr '\r' ' '`

    echo $ORIGINAL is renamed as $RENAMED
    mv $ORIGINAL $RENAMED
    sleep 1

done

