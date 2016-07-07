set -e

NEW_USER=$1
sudo adduser $NEW_USER
sudo su ${NEW_USER} << ENDCOMMANDS
cd
ssh-keygen -b 1024 -f ${NEW_USER} -t dsa
mkdir .ssh
chmod 700 .ssh
cat ${NEW_USER}.pub >> .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
chmod 777 ${NEW_USER}
ENDCOMMANDS
