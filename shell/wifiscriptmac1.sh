#!/bin/bash

UNAME_MAC="Darwin"
UNAME=`uname`
if [ $UNAME == $UNAME_MAC ]; then
    
    if [ $# -ne 0 ]; then

        box_id=$1

        /System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport scan | grep pressplay | cut -c1-32 > ~/file

        AVAILABLE=`cat ~/file`
        CONNECT=`cat ~/file | grep $box_id`
        STR=`echo ${CONNECT// /\ }`

    
            if [[ $STR == "$box_id"* ]];then
                echo "Connecting to " $STR     
                networksetup -setairportnetwork en0  "${STR}"
                echo "Connected..."
                #CURL=`curl pressplaytv.in/box-details`
                #echo $CURL
            else
                echo " Wifi network not available..."
                exit
        
             fi
    
    elif [ $# -eq 0 ]; then
        echo "Connecting to Pressplay-F2"
        networksetup -setairportnetwork en0 "PressPlay-F2" "enable@123"
        echo "Connected..."

    fi    

elif [ $UNAME != $UNAME_MAC ]; then
    
    if [ $# -ne 0 ];then
        
        box_id=$1
        
        `sudo iwlist wlan0 scan | grep ESSID | grep pressplay | sed 's/ESSID://' | sed 's/"//g'` > ~/file
        
        AVAILABLE=`cat ~/file`
        CONNECT=`cat ~/file | grep $box_id`
        STR=`echo ${CONNECT// /\ }`

            if [[ $STR == "$box_id"* ]];then
                echo "Connecting to " $STR
                #command
                echo "Connected..."

            else
                echo " Wifi network not available... "
                exit
            fi   

    elif [ $# -eq 0 ]; then
         echo "Connecting to PressPlay-F2"
         #command
         echo "Connected..."
    fi
fi

rm -rf ~/file

