
#!/bin/bash
# fast-create-sdcard.sh v0.1
# Author: Manish Bhatia <manishbhatias@gmail.com>
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# To create base card image [boot.tar.gz root.tar.gz and logs.tar.gz], mount the base card partitions and use the following commands
# tar zcf boot.tar.gz -C /media/pressplay/boot .
# tar zcf root.tar.gz -C /media/pressplay/root .
# tar zcf logs.tar.gz -C /media/pressplay/logs .

args=("$@")
  #get number of elements
  ELEMENTS=${#args[@]}
if [ $ELEMENTS != "0" ];then

  if [ ${args[0]} == "gparted" ]; then
    echo gparted
  elif [ ${args[0]} == "cardcopy" ]; then
    echo cardcopy  
  elif [ ${args[0]} == "full_erase_and_copy" ]; then  
    echo full_erase_and_copy
  fi


  if [ ${args[1]} == "north" ]
    then
    content_tar="northcontent.tar.gz"
  else
    content_tar="southcontent.tar.gz"
  fi

  VERSION="${args[2]}"
  echo "version" $VERSION
  VALUE="~/ppbox_99"
  echo "value" $VALUE
  START_DIR=$VALUE$VERSION
  echo $START_DIR
fi


  main_fun()

{
	
#######################################
AMIROOT=`whoami | awk {'print $1'}`
if [ "$AMIROOT" != "root" ] ; then

  echo "  **** Error *** must run script with sudo"
  echo ""
  read -p 'Press ENTER to finish' FILEPATHOPTION
  exit
fi

#######################################
#Percentage function
untar_progress ()
{
    TARBALL=$1;
    DIRECTPATH=$2;
    BLOCKING_FACTOR=$(($(gzip --list ${TARBALL} | sed -n -e "s/.*[[:space:]]\+[0-9]\+[[:space:]]\+\([0-9]\+\)[[:space:]].*$/\1/p") / 51200 + 1));
    tar --blocking-factor=${BLOCKING_FACTOR} --checkpoint=1 --checkpoint-action='ttyout=Written %u%  \r' -zxf ${TARBALL} -C ${DIRECTPATH}
}

#######################################
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
#echo "$args"

for i in $args  
#echo " "  
do
echo $i


DEVICEDRIVENAME=`cat /proc/partitions | grep -v $ROOTDRIVE | grep -n -o '\<sd.\>' | grep "${i}:" | awk -F: '{print $2}'`

  DRIVE=/dev/$DEVICEDRIVENAME
echo $DRIVE

  if [ -n "$DEVICEDRIVENAME" -a -e "$DRIVE" ]
  then
    ENTERCORRECTLY=1
  else
    echo "Invalid selection"
  fi

echo "$DRIVE was selected"

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

main_fun
cat <<EOM
+------------------------------------------------------------------------------+
|                           Now making partitions                              |
+------------------------------------------------------------------------------+
EOM
	echo $DRIVE

dd if=/dev/zero of=$DRIVE bs=1024 count=1
sync
parted --script $DRIVE -- mklabel msdos
parted --script $DRIVE -- mkpart primary fat32 4M 104M
parted --script $DRIVE -- mkpart primary ext2 104M 4200M
parted --script $DRIVE -- mkpart primary ext2 4200M 100%

mkfs.vfat -n "boot" ${DRIVE}1
mkfs.ext4 -L "root" ${DRIVE}2
mkfs.ext4 -L "content" ${DRIVE}3

echo "Operation Finished"
}


cardcopy()
{
main_fun
######################################################################
# Add directories for images

export PATH_TO_SDBOOT=$START_DIR/bootfs
export PATH_TO_SDROOTFS=$START_DIR/rootfs
export PATH_TO_SDCONTENTFS=$START_DIR/contentfs

cat <<EOM

+------------------------------------------------------------------------------+
|                           Mount the partitions                               |
+------------------------------------------------------------------------------+
EOM

mkdir -p $PATH_TO_SDBOOT
mkdir -p $PATH_TO_SDROOTFS
mkdir -p $PATH_TO_SDCONTENTFS

sudo mount -t vfat ${DRIVE}1 $PATH_TO_SDBOOT/
sudo mount -t ext4 ${DRIVE}2 $PATH_TO_SDROOTFS/
sudo mount -t ext4 ${DRIVE}3 $PATH_TO_SDCONTENTFS/

  cat <<EOM

+------------------------------------------------------------------------------+
|             Copying files now... will take minutes/hours/years               |
+------------------------------------------------------------------------------+
EOM

untar_progress $START_DIR/boot.tar.gz $PATH_TO_SDBOOT/
untar_progress $START_DIR/root.tar.gz $PATH_TO_SDROOTFS/
untar_progress $START_DIR/$content_tar $PATH_TO_SDCONTENTFS/

sync

cat <<EOM

+------------------------------------------------------------------------------+
|                               Cleaning Up                                    |
+------------------------------------------------------------------------------+
EOM

sudo umount -f $PATH_TO_SDBOOT
sudo umount -f $PATH_TO_SDROOTFS
sudo umount -f $PATH_TO_SDCONTENTFS

sudo rm -rf $PATH_TO_SDBOOT
sudo rm -rf $PATH_TO_SDROOTFS
sudo rm -rf $PATH_TO_SDCONTENTFS

echo "Operation Finished"

}

full_erase_and_copy()
{
 gparted
 cardcopy
 
}
if [ $ELEMENTS == 0 ]; then
    #statements  
  #export START_DIR= $LOCATION
  
        echo "1) gparted"
        echo "2) cardcopy"
        echo "3) full_erase_and_copy"

        val=("$@")
        read -p 'Select an option ' val

        case $val in
        1) gparted ;;
        2) cardcopy ;;
        3) full_erase_and_copy ;;
        esac
 fi 


exit