#!/bin/bash
#check rights
if [ "$(whoami)" != "root" ]; then
	echo "This script needs to be run as root! $ sudo sh setup.sh"
	exit 1
fi

if [ $SUDO_USER != "root" ]; then
	homedir="/home/$SUDO_USER" #We need the user's home directory, as this script needs to be run as SUDO/ROOT
else
	homedir=$HOME
fi
dl="Downloads"
scriptName="Soul's Setup Script for Arch Linux"
echo $scriptName
cd $homedir

#Setup Clean DNS Resolver
sudo chattr -i /etc/resolv.conf #make sure we can edit the file
sudo echo "#Created by $scriptName" > /etc/resolv.conf 			#Overwrite
sudo echo "nameserver 208.67.220.220 #OpenDNS1" >> /etc/resolv.conf	#append
sudo echo "nameserver 208.67.222.222 #OpenDNS2" >> /etc/resolv.conf	#append
sudo echo "nameserver 8.8.8.8 #GoogleDNS1" >> /etc/resolv.conf 		#append	
sudo chattr +i /etc/resolv.conf #make sure the file won't be edited

#TODO: ls -l



cd $homedir/$dl
#pwd
#essentials
sudo pacman --noconfirm -S cool-retro-term #<3 
sudo curl -sL https://asciinema.org/install | sh
#sudo pacman --noconfirm -S steam xchat python2
sudo pacman --noconfirm -S libg15 git hub wget

if [ ! -f "T5JI8or.jpg" ]; then
wget http://i.imgur.com/T5JI8or.jpg
fi
gsettings set org.cinnamon.desktop.background picture-uri "file:///$HOME/$dl/T5JI8or.jpg"

#wget https://aur.archlinux.org/packages/li/libgcrypt11/libgcrypt11.tar.gz
#tar xvzf libgcrypt11.tar.gz
#cd libcrypt11

#maxthon
#cd ~/Downloads
#wget http://dl.maxthon.com/linux/tars/maxthon-browser-stable-1.0.5.3-x86_64.tgz
#tar xvzf maxthon-browser-stable-1.0.5.3-x86_64.tgz 
#cd maxthon && sudo sh ./Install.sh
#sudo pacman -S gtkhotkey libgcrypt
