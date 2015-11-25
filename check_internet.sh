#!bin/bash
#set -e


PACKET_LOSS=`ping -c20 8.8.8.8 | grep % | awk '{print $6}'`

INTERNET_STATUS="INTERNET WORKING"

UNKNOWN_HOST='unknown host'

REACHABLE='reachable'


CHECK_PING=`ping -c4 8.8.8.8 >> ~/test.log 2>&1`
CHECK_OUTPUT=`cat ~/test.log`


if [[ $CHECK_OUTPUT == *"$UNKNOWN_HOST"* ]] || [[ $CHECK_OUTPUT == *"$REACHABLE"* ]];then

    INTERNET_STATUS="INTERNET NOT WORKING"
    PACKET_LOSS="100%"
fi


IST_TIME=`date | awk '{print $4}'`

#echo $IST_TIME >> file

UNIX_TIMESTAMP=`date +%s`

#echo $UNIX_TIMESTAMP >> file

echo $PACKET_LOSS,$IST_TIME,$UNIX_TIMESTAMP,$INTERNET_STATUS >> /home/pi/4G_ZTE
rm -rf ~/test.log
#cat file | tr "\n" ","
 
#rm -rf $DIR/file 
exit
