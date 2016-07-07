#!/bin/bash

# To create base card image [boot.tar.gz root.tar.gz and logs.tar.gz], mount the base card partitions and use the following commands
# tar zcf boot.tar.gz -C /media/pressplay/boot .
# tar zcf root.tar.gz -C /media/pressplay/root .
# tar zcf logs.tar.gz -C /media/pressplay/logs .

main_fun()
{
AMIROOT=`whoami | awk {'print $1'}`
if [ "$AMIROOT" != "root" ]; then
	echo "**** ERROR ***** must run script with sudo"
	echo ""
	read -p 'Press Enter to Finish' FILEPATHOPTION
	exit
fi

# show available SD card and select which to use
cat <<EOM
 
+------------------------------------------------------------------------------+
|                       List of available drives                               |
+------------------------------------------------------------------------------+
EOM

ROOTDRIVE=`mount | grep 'on / ' | awk {'print $1'} |  cut -c6-8`
echo "#  major   minor    size   name "
cat /proc/partitions | grep -v $ROOTDRIVE | grep -n -o '\<sd.\>'
#echo " "

ENTERCORRECTLY=0
while [ $ENTERCORRECTLY -ne 1 ]
do
args= "$@"
  read -p 'Enter Device Number #: ' args

for i in $args  
do

DEVICEDRIVENAME=`cat /proc/partitions | grep -v $ROOTDRIVE | grep -n -o '\<sd.\>' | grep "${i}:" | awk -F: '{print $2}'` 

  DRIVE=/dev/$DEVICEDRIVENAME 
  echo $DRIVE >> file
  DRIVES=`cat file | tr "\n" " "`
  echo $DRIVES
	
  if [ -n "$DEVICEDRIVENAME" -a -e "$DRIVE" ]
  then
    ENTERCORRECTLY=1
  else
    echo "Invalid selection"
  fi

echo "$DRIVES was selected"

#unmount drives if they are mounted
unmounted1=`df | grep '\<'$DEVICEDRIVENAME'1\>' | awk '{print $1}'`
unmounted2=`df | grep '\<'$DEVICEDRIVENAME'2\>' | awk '{print $1}'`
unmounted3=`df | grep '\<'$DEVICEDRIVENAME'3\>' | awk '{print $1}'`

if [ -n "$unmounted1" ]; then
  sudo umount -f ${DRIVE}1
fi
if [ -n "$unmounted2" ]; then
  sudo umount -f ${DRIVE}2
fi
if [ -n "$unmounted3" ]; then
  sudo umount -f ${DRIVE}3
fi	

done
done

}

gparted()

{
 
cat <<EOM
+------------------------------------------------------------------------------+
|                           Now making partitions                              |
+------------------------------------------------------------------------------+
EOM

dd if=/dev/zero of=$NUM bs=1024 count=1 
sync
parted --script $NUM -- mklabel msdos  
parted --script $NUM -- mkpart primary fat32 4M 104M 
parted --script $NUM -- mkpart primary ext2 104M 4200M   
parted --script $NUM -- mkpart primary ext2 4200M 100% 
 
mkfs.vfat -n "boot" ${NUM}1  
mkfs.ext4 -L "root" ${NUM}2 
mkfs.ext4 -L "content" ${NUM}3
  
echo "Operation Finished"

}
 

cardcopy()
{

export PATH_TO_SDBOOTFS=$START_DIR/bootfs 
export PATH_TO_SDROOTFS=$START_DIR/rootfs 
export PATH_TO_SDCONTENTFS=$START_DIR/contentfs 

cat <<EOM

+------------------------------------------------------------------------------+
|                           Mount the partitions                               |
+------------------------------------------------------------------------------+
EOM

mkdir -p $PATH_TO_SDBOOTFS
mkdir -p $PATH_TO_SDROOTFS
mkdir -p $PATH_TO_SDCONTENTFS

sudo mount -t vfat ${NUM}1 $PATH_TO_SDBOOTFS/
sudo mount -t ext4 ${NUM}2 $PATH_TO_SDROOTFS/
sudo mount -t ext4 ${NUM}3 $PATH_TO_SDCONTENTFS/

cat <<EOM

+------------------------------------------------------------------------------+
|             Copying files now... will take minutes/hours/years               |
+------------------------------------------------------------------------------+
EOM

tar zxf $START_DIR/boot.tar.gz -C $PATH_TO_SDBOOTFS   
tar zxf $START_DIR/root.tar.gz -C $PATH_TO_SDROOTFS 
tar zxf $START_DIR/$content_tar -C $PATH_TO_SDCONTENTFS  
 
sync

cat <<EOM

+------------------------------------------------------------------------------+
|                               Cleaning Up                                    |
+------------------------------------------------------------------------------+
EOM

sudo umount -f $PATH_TO_SDBOOTFS
sudo umount -f $PATH_TO_SDROOTFS
sudo umount -f $PATH_TO_SDCONTENTFS

sudo rm -rf $PATH_TO_SDBOOTFS
sudo rm -rf $PATH_TO_SDROOTFS
sudo rm -rf $PATH_TO_SDCONTENTFS


echo "Operation Finished"

}

full_erase_and_copy()
{
  
 gparted
 cardcopy
 
}


args=("$@")
#get number of elements
ELEMENTS=${#args[@]}

if [ $ELEMENTS == "1" ];then

	if [ ${args[0]} == "gparted" ]; then
		main_fun
	    	echo ">>>>>>>>>>>>>" $DRIVES
	
		for NUM in $DRIVES 	
		do
		echo "num : " $NUM
		
		gparted $NUM &
	
		done 	
		wait
		sudo rm -rf file

	elif [ ${args[0]} == "cardcopy" ]; then
	        cardcopy $DRIVE $CONTENT_TYPE $CONTENT_VERSION 
		exit
	 
	elif [ ${args[0]} == "full_erase_and_copy" ]; then  
		full_erase_and_copy $DRIVE $CONTENT_TYPE $CONTENT_VERSION 
		exit
 	 fi

elif [ $ELEMENTS == "3" ];then

  	if [ ${args[0]} == "gparted" ]; then
 		
		main_fun    
		for NUM in $DRIVES
		do	
		gparted $NUM &
		done 
     		wait
  		sudo rm -rf file
	
	elif [ ${args[0]} == "cardcopy" ]; then
		
		CONTENT_TYPE=$2
		CONTENT_VERSION=$3     
		main_fun
		for NUM in $DRIVES
		do		
		cardcopy $NUM $CONTENT_TYPE $CONTENT_VERSION & 
		done    		
		wait
		sudo rm -rf file

 	elif [ ${args[0]} == "full_erase_and_copy" ]; then
	  
		CONTENT_TYPE=$2
      		CONTENT_VERSION=$3     
		main_fun		
		for NUM in $DRIVES
		do     		
		full_erase_and_copy $NUM $CONTENT_TYPE $CONTENT_VERSION &
		done     
		wait
 		sudo rm -rf file
   
   	fi
	

if [ ${args[1]} == "north" ]
then
    content_tar="northcontent.tar.gz"
else
     content_tar="southcontent.tar.gz"
fi
	
CONTENT_VERSION="${args[2]}"
  
VALUE="/home/pressplay/ppbox_99"
  
START_DIR=$VALUE$CONTENT_VERSION
  
  
elif [ $ELEMENTS == 0 ]; then
     
        echo "1) gparted"
        echo "2) cardcopy"
        echo "3) full_erase_and_copy"

      
        read -p 'Select an option ' val

    #    case $val in
     #   1) gparted ;;
            
      #  2) cardcopy ;;
            	
       # 3) full_erase_and_copy ;;
            

        #esac
	if [ $val == "gparted" ];then
		gparted $DRIVE &
    wait
	elif [ $val == "cardcopy"];then
		cardcopy $DRIVE $CONTENT_TYPE $CONTENT_VERSION
    wait
	else  gparted $DRIVE &
	      cardcopy $DRIVE $CONTENT_TYPE $CONTENT_VERSION &
        wait
	fi 	
fi






