#!/bin/sh

# manually update pacman.conf first in the etc/pacman.conf

#update mirror list with the fastest mirrors
sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist

#unistall archo-install-scripts because it will not be necessary again
sudo pacman -R arch-install-scripts amd-ucode archinstall brltty nano

#sync and update packages already installed
sudo pacman -Syu

#Packages from arch linux repository
sudo pacman --noconfirm --needed -S $(<packages-list.txt)

#Install Yay
cd /home/frank/.config
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si

#Packages from aur
yay --noconfirm --needed -Sy $(<aur-packages-list.txt) 

# Now we are entering .config to install and configur the programs i use
cd /home/frank/.config

#Dwm
#patches i am using: alpha_patch, alpha_focus_highlight_patch, scrollback_patch, scrollback_mouse_patch, vim_browse_patch
git clone https://github.com/Andre-gonzalez/my_dwm.git
cd my_dwm
sudo make clean install
cd ..

#st
git clone https://github.com/Andre-gonzalez/my-st.git
cd my-st
sudo make clean install
cd ..

#dmenu
git clone https://git.suckless.org/dmenu
cd dmenu
sudo make clean install
cd ..

#dwm-bar
git clone https://git.suckless.org/dwmstatus
cd dwmstatus
make
make PREFIX=/usr install
cd ..
git clone https://github.com/Andre-gonzalez/my-dwm-bar
cd my-dwm-bar
sudo make clean install
cd /home/frank/.config

#slock to block the screen 
#patches i use are: capscolor and dpms
#xautolock if you want to block the screen after a specific period of time
git clone https://github.com/Andre-gonzalez/my_slock.git
cd my_slock
sudo make clean install
cd ..

#unistall unnedded dependencies
pacman -Qdt | sudo pacman -Rns

#remove cache from old packages
sudo pacman -Sc

#Copying dot files to the home directory
cp /home/frank/arch_setup/dot-files/.xinitrc ~/.xinitrc
cp /home/frank/arch_setup/dot-files/.bash_profile ~/.bash_profile
cp /home/frank/arch_setup/dot-files/.bashrc ~/.bashrc
cp /home/frank/arch_setup/dot-files/.insync-git-ignore ~/.insync-git-ignore
cp /home/frank/arch_setup/dot-files/.vimrc ~/.vimrc
cp -r /home/frank/arch_setup/dot-files/.vim ~/.vim
cp /home/frank/arch_setup/dot-files/.xbindkeysrc ~/.xbindkeysrc
cp /home/frank/arch_setup/dot-files/.gitconfig ~/.gitconfig

#Moving the conectar-xm3-sh script to the /usr/local/bin folder so it can be executed by dmenu
cd /home/frank/arch_setup
cp conectar-xm3.sh conectar-redmi.sh scrot-copy-to-clipboard.sh /usr/local/bin
cd /usr/local/bin
chmod +x conectar-xm3.sh conectar-redmi.sh scrot-copy-to-clipboard.sh
cd /home/frank

# Enable cron in systemd
sudo systemctl enable cronie.service --now

#bluetooth configuration
modprobe btusb
sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service
bluetoothctl power on
bluetoothctl agent on
bluetoothctl default-agent
#making bluetooth automatically start after start a computer
#open the file below
#sudo vim /etc/bluetooth/main.conf
#Set AutoEnable=true
pulseaudio --start
# use pavucontrol to switch audio

#etc.
# To-do:
# 1.Add the scrollback support to st
# 2.Config spotifytui and spotifyd
# 3.Try Zsh
# 4.Learn to config keyboard shortcut to run programs
