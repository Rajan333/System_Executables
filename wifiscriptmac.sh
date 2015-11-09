SSID=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport scan | grep pressplay | cut -c1-32`

#echo ${SSID} | tr -s ' ' | tr ' ' '\ '
NEWSSID= echo ${SSID} | sed -e 's/ /\ /g'
#SPLIT = $($SSID | tr " " "\n" )

echo "${NEWSSID}" 

#for LIST in "${SSID}"

#do
 #   AVAILABLE=`echo $LIST`
#echo $LIST
    networksetup -setairportnetwork en0  "${NEWSSID}"
    #CURL = `curl pressplaytv.in/box_details`
    #echo $CURL
#done

exit 0



