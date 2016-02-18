#!/bin/bash

set -e

REGION="ap-southeast-1"

# LIST INSTANCES NAMES IDS AND AVAILABILITY ZONE
list_instances()
{
    aws ec2 describe-instances --query "Reservations[].Instances[].[InstanceId,Tags[].Value,Placement.AvailabilityZone]"  --output text | column -x | sort | nl > ~/list.txt
    cat ~/list.txt

    echo "Select an INSTANCE"
    read option

    OPTION=`cat ~/list.txt | awk '{print $1}' | grep -w $option`
    INSTANCE=`cat ~/list.txt | awk '{first = $1; $1 = ""; second = $2; $2 = ""; third = $3; $3 = "";  print $0; }' | sed -n "$OPTION"p`
    INSTANCE_ID=`cat ~/list.txt | sed -n "$OPTION"p | awk '{print $2}'`
    AZ=`cat ~/list.txt | sed -n "$OPTION"p | awk '{print $3}'`
    echo "instance name: " $INSTANCE
    echo "instance_id: "  $INSTANCE_ID
    echo "AZ: " $AZ
    echo "Enter Size of Disk(G.B)"
    read SIZE

}

# CREATE A VOLUME FOR AN INSTANCE
create_volume()
{
    list_instances

    # CREATE A VOLUME 
    # aws ec2 create-volume --size $SIZE --region $REGION --availability-zone $AZ --volume-type gp2 > ~/vol.json
    VOLUME_ID=`echo $(jq -r '.VolumeId' ~/vol.json)`
    echo "vol_id: " $VOLUME_ID
}

# ATTACH A VOLUME
attach_volume()
{
    create_volume
    aws ec2 attach-volume --volume-id $VOLUME_ID --instance-id $INSTANCE_ID --device /dev/sdz
}

delete_volume()
{
    aws ec2 describe-volumes --query "Volumes[].Attachments[].[InstanceId,VolumeId,State]" --output text | nl > ~/del_vol.txt
    cat ~/del_vol.txt
    echo "SELECT OPTION"
    read del_option
    VOL_ID=`cat ~/del_vol.txt | sed -n "$del_option"p | awk '{print $3}'`
    echo $VOL_ID
    exit
#    aws ec2 delete-volume --volume-id $VOL_ID
}


echo "Select an Option"
echo "1) Attach Volume"
echo "2) Delete Volume"
read choice
case $choice in
    1) attach_volume
       rm -rf ~/list.txt ~/vol.json;;
    
    2) echo "deleting"
       delete_volume
       rm -rf ~/del_vol.txt;;
    
    *) echo "Plz don't try be smart as Gulzari..." 
esac


