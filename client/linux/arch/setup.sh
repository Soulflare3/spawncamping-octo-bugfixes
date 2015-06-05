#!/bin/bash
#check rights
if [ "$(whoami)" != "root" ]; then
	echo "This script needs to be run as root! $ sudo sh setup.sh"
	exit 1
fi

############ VARS ############

if [ "$SUDO_USER" != "root" ]; then
	homedir="/home/$SUDO_USER"	 #We need the user's home directory, because this script needs to be run as SUDO/ROOT
else
	homedir="$HOME"			 #if user is actually root, use /root
fi

dl="Downloads"
scriptName="Soul's Setup Script for Arch Linux"
UseNanoAsDefault=false
UseViAsDefault=false

#git info (only used if .gitconfig does not already exist)
email=""	#Email for git contributions
name=""		#Name for git contributions 

############ END VARS ############
#TODO: Make script die if variables aren't edited first?
#TODO: Consolidate pacman commands

if ( "$UseNanoAsDefault" && "$UseViAsDefault" ); then
	echo "You can't have 2 default Editors! Edit setup.sh"
	exit 1
fi

echo "$scriptName"
cd "$homedir"

#Setup Nano
echo "set const" > .nanorc
echo "set mouse" >> .nanorc
echo "unset nonewlines" >> .nanorc
echo "set nowrap" >> .nanorc
echo "set morespace" >> .nanorc
echo "set smooth" >> .nanorc
echo "unset tabstospaces" >> .nanorc
echo "set softwrap" >> .nanorc
echo "set backup" >> .nanorc
echo "set locking" >> .nanorc
echo "set wordbounds" >> .nanorc
echo ".nanorc created"

if ( "$UseNanoAsDefault" ); then
	export EDITOR=nano
	echo "Default editor set to Nano"
fi

if ( "$UseViAsDefault" ); then
	export EDITOR=vi
	echo "Default editor set to vi"
fi


#Setup Git Config
if [ ! -f ".gitconfig" ]; then						#if no .gitconfig found
	echo "[user]" > .gitconfig					#Create new .gitconfig
	echo "email = $email" >> .gitconfig 				#user.email
	echo "name = $name" >> .gitconfig 				#user.name
	echo ".gitconfig created"
fi

#Setup Clean DNS Resolver
sudo chattr -i /etc/resolv.conf 					#make sure we can edit the file
sudo echo "#Created by $scriptName" > /etc/resolv.conf 			#Overwrite
sudo echo "nameserver 208.67.220.220 #OpenDNS1" >> /etc/resolv.conf	#append
sudo echo "nameserver 208.67.222.222 #OpenDNS2" >> /etc/resolv.conf	#append
sudo echo "nameserver 8.8.8.8 #GoogleDNS1" >> /etc/resolv.conf 		#append	
sudo chattr +i /etc/resolv.conf 					#make sure the file won't be edited

#TODO: ls -l

cd "$homedir"/"$dl"
#pwd

#essentials
sudo curl -sL https://asciinema.org/install | sh
#sudo pacman --noconfirm -S steam xchat python2
sudo pacman --noconfirm -S libg15 git hub wget pastebinit cool-retro-term irssi

############ IRSSI SCRIPTS ############

cd $homedir

if [ ! -d ".irssi" ]; then
	mkdir .irssi
fi
cd .irssi

if [ ! -d "scripts" ]; then
	mkdir scripts
fi
cd scripts

if [ ! -d "autorun" ]; then
	mkdir autorun
fi


########### Continue Setups ############

cd $homedir/$dl

if [ ! -f "T5JI8or.jpg" ]; then #Check if the file's already been downloaded, in case the script has already been run once
	wget http://i.imgur.com/T5JI8or.jpg
fi
gsettings set org.cinnamon.desktop.background picture-uri "file:///${HOME#/}/${dl}/T5JI8or.jpg"

#wget https://aur.archlinux.org/packages/li/libgcrypt11/libgcrypt11.tar.gz
#tar xvzf libgcrypt11.tar.gz
#cd libcrypt11

#maxthon
#cd ~/Downloads
#wget http://dl.maxthon.com/linux/tars/maxthon-browser-stable-1.0.5.3-x86_64.tgz
#tar xvzf maxthon-browser-stable-1.0.5.3-x86_64.tgz 
#cd maxthon && sudo sh ./Install.sh
#sudo pacman -S gtkhotkey libgcrypt
