#!/bin/bash

set -e

while read line
do
    youtube-dl $line
    sleep 1
done<$1
