#!/bin/bash
#check rights
if [ "$(whoami)" != "root" ]; then
	echo "This script needs to be run as root! $ sudo sh setup.sh"
	exit 1
fi

############ VARS ############

if [ "$SUDO_USER" != "root" ]; then
	homedir="home/$SUDO_USER"	 #We need the user's home directory, because this script needs to be run as SUDO/ROOT
else
	homedir="$HOME"			 #if $HOME is actually correct (user is root)
fi

dl="Downloads"
irssiRepo="http://scripts.irssi.org/scripts"
irssiScripts=( "scriptassist" "url_log" "apm" "bandwidth" "crapbuster"  ) #script name without .pl extension (assumes all .pl files)
yaourtInstall=( "foxitreader" "copyq" "copyq-plugin-itemweb" ) #packages for yaourt to install, since it can't handle more than one at a time
scriptName="Soul's Setup Script for Arch Linux"
UseNanoAsDefault=false 			#If both are false, no changes will be made to EDITOR
UseViAsDefault=false			#If both are false, no changes will be made to EDITOR

#git info (only used if .gitconfig does not already exist)
#probably not good to leave blank if firstrun
gitEmail=""			#Email for git contributions
gitName=""			#Name for git contributions 
gitPush=""			#Push setting for git contributions (matching | simple | current)
cleanResolver=false		#Should we clean the resolv.conf file? false=leave alone, true=write fresh (OpenDNS, then GoogleDNS)
firstRun=false			#change to false when ready for script to run
############ END VARS ############
					#TODO: Make script die if variables aren't edited first?
					#TODO: Consolidate pacman commands
if ( "$firstRun" ); then
	echo "Please edit this script's variables before running the first time"
	exit 1
fi
if ( "$UseNanoAsDefault" && "$UseViAsDefault" ); then
	echo "You can't have 2 default Editors! Edit setup.sh"
	exit 1
fi

echo "$scriptName"
cd "/$homedir"

if ( "$UseNanoAsDefault" ); then
	export EDITOR=nano
	export VISUAL=nano
	#Setup Nano (~/.nanorc)
	#Some of this is redundant, but we don't check global .nanorc, so we set/unset anyway
	#Sets/unsets that are redundant won't hurt anything, unless you have REALLY tight disk space.
	#In that case, why are you running this script?
	#I don't set colors because in cool-retro-term, colors don't matter as much (they're dulled out)
	echo "set const" > .nanorc
	echo "set mouse" >> .nanorc
	echo "unset nonewlines" >> .nanorc
	echo "set nowrap" >> .nanorc
	echo "set morespace" >> .nanorc
	echo "set smooth" >> .nanorc
	echo "unset tabstospaces" >> .nanorc
	echo "unset softwrap" >> .nanorc
	echo "set backup" >> .nanorc
	echo "set locking" >> .nanorc
	echo "set wordbounds" >> .nanorc
	echo ".nanorc created"
	echo "Default editor set to Nano"
fi

if ( "$UseViAsDefault" ); then
	export EDITOR=vi
	export VISUAL=vi
	echo "Default editor set to vi"
	#TODO: Setup VIM (~/.vimrc)
	#HA that would reqire me to actully use vim 
	echo "No .vimrc defaults defined, ignoring"
fi

#set automatic yaourt
if [ ! -f ".yaourtrc" ]; then
	echo "NOCONFIRM=1" > .yaourtrc
	echo "BUILD_NOCONFIRM=1" >> .yaourtrc
	echo "EDITFILES=0" >> .yaourtrc
	#UP_NOCONFIRM=0     # No prompt while build upgrades (including -Sbu)
	#PU_NOCONFIRM=0     # Add --noconfirm to $PACMAN -U
	#NOENTER=1
fi


#Setup Git Config
if [ ! -f ".gitconfig" ]; then						#if no .gitconfig found
	echo "[user]" > .gitconfig					#Create new .gitconfig
	echo "email = $gitEmail" >> .gitconfig 				#user.email
	echo "name = $gitName" >> .gitconfig 				#user.name
	echo "[push]" >> .gitconfig
	echo "default = $gitPush" >> .gitconfig
	echo ".gitconfig created"
fi

#Setup Clean DNS Resolver
if ( "$cleanResolver" ); then
	sudo chattr -i /etc/resolv.conf 					#make sure we can edit the file
	sudo echo "#Created by $scriptName" > /etc/resolv.conf 			#Overwrite
	sudo echo "nameserver 208.67.220.220 #OpenDNS1" >> /etc/resolv.conf	#append
	sudo echo "nameserver 208.67.222.222 #OpenDNS2" >> /etc/resolv.conf	#append
	sudo echo "nameserver 8.8.8.8 #GoogleDNS1" >> /etc/resolv.conf 		#append	
	sudo chattr +i /etc/resolv.conf 					#make sure the file won't be edited
fi
#TODO: ls -l


#essentials
sudo curl -sL https://asciinema.org/install | sh
sudo pacman --noconfirm -Sy
sudo pacman --noconfirm --needed -S  wget
sudo wget -O "/etc/pacman.conf" "https://raw.githubusercontent.com/Soulflare3/spawncamping-octo-bugfixes/master/client/linux/arch/pacman.conf" 
sudo pacman --noconfirm -Sy
#sudo pacman --noconfirm --needed -S steam multilib-devel ttf-liberation lib32-alsa-plugins lib32-nvidia-utils
sudo pacman --noconfirm --needed -S libg15 git hub openssh pastebinit cool-retro-term irssi xchat python2 teamspeak3 chromium gedit yaourt
sudo pacman --noconfirm --needed -S wine playonlinux webkitgtk2 mirage python2-numpy curl yajl rsync customizepkg aurvote
sudo pacman --noconfirm --needed -S weechat lua ruby nodejs tk npm gtk2-perl htop lsof strace cmake extra-cmake-modules expac

#awk 'NF>=2' <(expac "%n %O") > optdeps #Command that lets you see optional dependencies for packages on your system.
					#output is written to ./optdeps http://unix.stackexchange.com/a/53092

#get wget syntax for miblo (only download if newer)
#clipboard manager http://hluk.github.io/CopyQ/ ditto replacement?

for i in "${yaourtInstall[@]}"
do
	su "$SUDO_USER" -c "yaourt --noconfirm --needed -Sy $i"
done


#Set Chromium as default Browser
cd "/$homedir/.local/share/applications"
echo "[Default Applications]" > mimeapps.list
echo "text/html=chromium.desktop" >> mimeapps.list
echo "x-scheme-handler/http=chromium.desktop" >> mimeapps.list
echo "x-scheme-handler/https=chromium.desktop" >> mimeapps.list
echo "x-scheme-handler/about=chromium.desktop" >> mimeapps.list
echo "x-scheme-handler/unknown=chromium.desktop" >> mimeapps.list

############ IRSSI SCRIPTS ############

cd "/$homedir"

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

for i in "${irssiScripts[@]}"
do
	if [ ! -f "$i.pl" ]; then
		wget "$irssiRepo/$i.pl"
		echo "$i.pl installed"
	else
		echo "$i.pl already exists"
	fi
done

########### Continue Setups ############

cd "/$homedir/$dl"
#Using the Fallout4 prerelease background
if [ ! -f "T5JI8or.jpg" ]; then #Check if the file's already been downloaded, in case the script has already been run once
	wget http://i.imgur.com/T5JI8or.jpg
fi

sudo chown "$SUDO_USER" "/$homedir/.config/dconf" -R
chmod u+w "/$homedir/.config/dconf" -R
uri=$(ls "/$homedir/$dl/T5JI8or.jpg")
su "$SUDO_USER" -c "gsettings set org.cinnamon.desktop.background picture-uri 'file:///$uri'"

#wget https://aur.archlinux.org/packages/li/libgcrypt11/libgcrypt11.tar.gz
#tar xvzf libgcrypt11.tar.gz
#cd libcrypt11

#maxthon
#cd ~/Downloads
#wget http://dl.maxthon.com/linux/tars/maxthon-browser-stable-1.0.5.3-x86_64.tgz
#tar xvzf maxthon-browser-stable-1.0.5.3-x86_64.tgz 
#cd maxthon && sudo sh ./Install.sh
#sudo pacman -S gtkhotkey libgcrypt
