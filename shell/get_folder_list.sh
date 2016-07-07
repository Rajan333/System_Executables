#!/bin/bash

set -e

LOCATION=$1
FIRST_TIMESTAMP=$2
SECOND_TIMESTAMP=$3

LIST=`find $LOCATION -type f -newermt $FIRST_TIMESTAMP ! -newermt $SECOND_TIMESTAMP`

echo $LIST | tr -d "$LOCATION/"  

