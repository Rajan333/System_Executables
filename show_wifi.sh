#!/bin/bash

set -e

CONNECTED=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep "SSID" | sed -e 's/BSSID:/\ /g' | sed 1d | sed -e 's/SSID: /\ /g'`

echo " You are connected to :" $CONNECTED


