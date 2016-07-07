#!/bin/bash

set -e

# Unzip the zip folder

#unzip /root/First-Ride-master/zipfolder/complete_content.zip

mkdir -p /mnt/boot /mnt/root /mnt/content 

SELECTCARD=$*

for card in ${SELECTCARD[@]}
do
	 DRIVE="/dev/sd"$card
	 BOOTDRIVE=$DRIVE"1"
	 ROOTDRIVE=$DRIVE"2"
	 CONTENTDRIVE=$DRIVE"3"
	 echo $BOOTDRIVE $ROOTDRIVE $CONTENTDRIVE

	# Mount card
	mount $BOOTDRIVE /mnt/boot
	mount $ROOTDRIVE /mnt/root
	mount $CONTENTDRIVE /mnt/content
	
	mkdir -p /mnt/content/content /mnt/content/posters /mnt/content/json
	
	# Copy content from system to card
	cp -afv downloadFiles/*.png /mnt/content/posters/
	cp -afv downloadFiles/*.mp4 /mnt/root/home/pi/Beam/static/free-content/

	umount $BOOTDRIVE $ROOTDRIVE $CONTENTDRIVE
 		  
done


