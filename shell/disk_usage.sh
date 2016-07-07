#!/bin/bash
CURRENT=$(df / | awk 'FNR == 2 {print $5}' | sed 's/%//g')
CURRENT_DATA=$(df /data | awk 'FNR == 2 {print $5}' | sed 's/%//g')
MOAR_DATA=$(df /moar_data | awk 'FNR == 2 {print $5}' | sed 's/%//g')
THRESHOLD=95

if [ "$CURRENT" -gt "$THRESHOLD" ] ; then
    echo `date` 'Sending critical email. Disk almost full.'
    mail -s 'Disk Space Alert' gaurav@pressplaytv.in,mayank@pressplaytv.in,rajan@pressplaytv.in << EOF
Your root partition remaining free space is critically low. Used: $CURRENT%
EOF
elif [ "$CURRENT_DATA" -gt "$THRESHOLD" ] ; then
    echo `date` 'Sending critical email. Disk almost full.'
    mail -s 'Disk Space Alert' gaurav@pressplaytv.in,mayank@pressplaytv.in,rajan@pressplaytv.in << EOF
Your data partition remaining free space is critically low. Used: $CURRENT_DATA%
EOF
elif [ "$MOAR_DATA" -gt "$THRESHOLD" ] ; then
    echo `date` 'Sending critical email. Disk almost full.'
    mail -s 'Disk Space Alert' gaurav@pressplaytv.in,mayank@pressplaytv.in,rajan@pressplaytv.in << EOF
Your moar_data partition remaining free space is critically low. Used: $MOAR_DATA%
EOF
else
    echo `date` 'Disk space used:' ${CURRENT}'% [ROOT],' ${CURRENT_DATA}'% [DATA],' ${MOAR_DATA}'% [MOAR_DATA]'
fi
