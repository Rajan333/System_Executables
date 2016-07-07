#!/bin/bash

declare -a array=(bc xauth newgrp envsubst node-inspector rngtest dc aseqnet gpg2 pkttyagent pinentry pinentry-curses pkcheck busctl node-debug chroot dnsmasq arm-linux-gnueabihf-g++ nfokey rbash pod2latex systemd unxz unlzma md5sum.textutils md5sum systemd-cgtop systemd-path systemd-cgls systemd-delta systemd-run systemd-cat  pod2latex.bundled pod2man pod2text pod2usage sdmem perl5.20.2  debconf-communicate debconf-set-selections delgroup info install-info install infobrowser htop pstree.x11 ptx pl2pm lspgpot lua sulogin lua5.1 luajit luajit-2.0.3 arm-linux-gnueabihf-g++-4.9 arm-linux-gnueabihf-gcc arm-linux-gnueabihf-gcc-4.9 c++ c89 c89-gcc c99 c99-gcc cc dbus-run-session flock funzip g++ g++-4.9 localedef mcc nohup pkcheck pkexec stdbuf timeout unzipsfx hwclock mount.nfs mount.nfs4 rarp raw start-stop-daemon netstat sed decode_tm6000  screen pkttyagent systemd-stdio-bridge unshare utmpdump wc xxd yes fsck debugfs wall iwevent fakeroot-sysv killall5 fakeroot-tcp parted wpa_cli showmount dash dd ed modeline2fb red rnano sh sh.disturb su netstat sh.distrib nc.traditional xargs view vim.tiny vim.basic vimdiff watch tload linux32 troff nl tsort tzselect node unexpand uniq nodejs msginit linux64 nsenter ntpdc ntpq numfmt od omshell openssl logger paste patch perl c++filt pg pgrep pic pico piconv preconv pr cksum chpasswd xz c++built fakeroot python recode-sr-latin rev rview rvim script python2 sha1sum shasum shuf soelim sort sha224sum split ssh-keygen sensible-editor strings sum tac sha256sum tail taskset tbl sha384sum sha512sum python2.7 fmt editor pppdump rmt rmt-tar arm-linux-gnueabihf-as arm-linux-gnueabihf-c++filt arm-linux-gnueabihf-cpp arm-linux-gnueabihf-strings arm-linux-gnueabihf-cpp-4.9 cpp-4.9 cpp crontab col colcrt colrm column c++filt chardetect chfn eqn gpg gpgsplit gpgv gpic groff grops grotty gtbl grog hd head hexdump iconv top expand deluser gencat geqn fold expr factor msgattrib msgconv ex msggrep msgunfmt neqn msguniq chsh chardet bc xz c++built arm-linux-gnueabihf-cpp-4.9 btmmdiagnose bc batch base64 banner as asa lzma tee xzdec ts ifdata pcretest lzmainfo lzmadec isutf8 gyes gxargs gwc gupdatedb guniq gunexpand gtsort gtee gtail gtac gsum gsplit gsort gshuf gsha512sum gsha384sum gsha256sum gsha224sum gsha1sum gptx gpr gpaste god gnumfmt gnl gmd5sum ghead gfold gfmt gfactor gexpand bash vim  vi gedit nano gbase64 ksh cat nautilus bashbug gcat gcksum gdd);

declare -a ignore_array=(vimtutor protector.sh passwd dpid speaker-test gpgparsemail pam-auth-update alsamixer aptitude aptitude-curses aseqdump tasksel vidir systemctl ntp-wait batch perlthanks perlbug pod2html pstruct splain a2p a2p.16 a2p5.16 a2p5.18 2to3 2to32 cpan debconf-apt-progress iptables-xml c2ph instmodsh line printerbanner git-upload-archive git-receive-pack ncdu);

declare -a help_array=(iptables-restore reboot poweroff json_pp install-menu ip6tables-restore su-to-root  infotocap nroff ul grpck grpconv grpunconv invoke-rc.d pppd pwck pwconv mathematica iptables-xml mcc psfaddtable psfxtable raspistill raspivid ucfr whiptail wolframe e2fsck fsck fsck.cramfs fsck.ext2 fsck.ext3 fsck.ext4 fsck.ext4dev fsck.minix mkfs.cramfs mkfs.minix mkhomedir_helper plymouthd aprd ifplugd install-sgmlcatalog nethogs nfnl_osf pam_getenv pppoe-discovery sshd config_data config_data.diverted debconf debconf-loadtemplate debconf-mergetemplate dnie-tool edidparser git-receive-pack git-shell git-upload-archive git-upload-pack h2xs helpztags mtrace prename ptar qmi-network rlogin rsh);

echo $PATH
for i in ${PATH//:/ }; 
 do 
        
	FILES=$i"/*"
    
   for k in $FILES
   do
	st=0
	for l in "${array[@]}"
	do
        
		xbase=${k##*/}
		
		if [ "$l" == "$xbase" ]; then	
        		
            echo $l
          	 $l --version 

			vers=`echo $?`
		    echo $l  $vers
            if [ $vers -gt 2 -a $vers -lt 128 ];
            then
              
            echo "System level : " "$xbase -->  $vers" >> syserrors
            elif [ $vers -gt 127 ]
            then
                
              echo "Kernel level : " "$xbase --> $vers" >> kererrors
        fi
            st=1 
		    
    		fi
	done

    for m in "${help_array[@]}"
    do
          
       mbase=${k##*/}
            
       if [ "$m" == "$mbase" ]; then
              
            echo $m
            $m --help
                 
              vers2=`echo $?`
              echo $m  $vers2
              
              if [ $vers2 -gt 2 -a $vers2 -lt 128 ];
              then
                      
              echo "System level : " "$mbase -->  $vers2" >> syserrors
              elif [ $vers2 -gt 127 ]
              then
                          
                  echo "Kernel level : " "$mbase --> $vers2" >> kererrors
               fi
        st=1
                              
        fi
     done


	for p in "${ignore_array[@]}"
	do

		base=${k##*/}
		if [ "$p" == "$base" ];then
			st=1
		fi
	done
		
	if [ $st -eq 0 ];then
		
		base=${k##*/}
		echo $base
	         $base  
		vers1=`echo $?`

        if [ $vers1 -gt 2 -a $vers1 -lt 128 ];
        then
        
          
        echo "System level :  " "$base --> $vers1" >> syserrors 
              
            elif [ $vers1 -gt 127 ]
                  then
                      
        echo "Kernel level : " " $base --> $vers1" >> kererrors
        fi  
	fi
   done

done

rm -rf /home/pi/ntpkey_*
rm -rf /home/pi/messages.pot

exit 0
