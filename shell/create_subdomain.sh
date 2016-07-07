#!/bin/bash

set -e 

NEW_USER=$1

echo $NEW_USER

sudo mkdir -p /home/$NEW_USER/nginx_conf
sudo chown ubuntu:ubuntu /home/$NEW_USER/nginx_conf

cat /home/ubuntu/nginx_users/dev | sed  "s/test/$NEW_USER/" > /home/$NEW_USER/nginx_conf/$NEW_USER

sudo chown ubuntu:ubuntu /home/$NEW_USER/nginx_conf/$NEW_USER

sudo ln -s /home/$NEW_USER/nginx_conf/$NEW_USER /etc/nginx/sites-available/
sudo ln -s /home/$NEW_USER/nginx_conf/$NEW_USER /etc/nginx/sites-enabled/

sudo chown $NEW_USER:$NEW_USER /home/$NEW_USER/nginx_conf
sudo chown $NEW_USER:$NEW_USER /home/$NEW_USER/nginx_conf/$NEW_USER

sudo service nginx restart
