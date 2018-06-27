#!/bin/bash

											
#	+------------------------------------------------------------------+	
#	| This Script will install basic dependencies on the ubuntu server |	
#	+------------------------------------------------------------------+	
											


sudo apt-get update -y
sudo apt-get install zsh git-core vim wget -y
sudo apt-get install figlet -y

clear
figlet Dependencies
sleep 5

sudo apt-get install python-pip gcc openssl jq uwsgi -y
sudo pip install --upgrade pip
sudo pip install supervisor pymongo virtualenv flask
clear

##  Install OH MY ZSH  ##
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
sudo chsh -s /bin/zsh $USER
sed -i 's/robbyrussell/gentoo/g' ~/.zshrc

## Install Nginx ##
sudo apt-get install nginx -y
sudo service nginx start

## Install ffmpeg ##
sudo apt-get install ffmpeg -y

echo "Dependencies Installed"
