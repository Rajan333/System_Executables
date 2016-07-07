#!/bin/bash

set -e    


        /System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport scan | grep pressplay | cut -c1-32 > ~/file

        AVAILABLE=`cat ~/file`
        CHECK_BOX_ID=`cat ~/file | awk '{print $1}'`   
        LIST=`cat ~/file`
        for BOX_ID in $CHECK_BOX_ID
        do
           CONNECT=`cat ~/file | grep $BOX_ID`
            #STR=`echo ${CONNECT// /\ }`
    
    
        #    for CHECK in ${CONNECT// /\ }
         #   do
          #      echo $CHECK
                exit
                if [[ $CHECK == "$BOX_ID"* ]];then
                    echo "Connecting to " $CHECK     
                    networksetup -setairportnetwork en0  "${CHECK}"
                    echo "Connected..."
                    echo "Box-details of $BOX_ID are: "
                    curl pressplaytv.in/box-details
            
                else
                    echo " Wifi network not available..."
                exit
        
                fi  
            done         
        done
        
rm -rf ~/file

