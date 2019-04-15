#!/bin/bash
#set -eoux pipefail
IFS=$'\n\t'

################################################
# GUI
################################################

echo 'Installing GUI packages...'

apt-get install -y xauth
apt-get install -y xorg
apt-get install -y openbox
apt-get install -y sakura
apt-get install -y firefox-esr

# This is a deprecated package in ubuntu so might cause problems in future releases.
apt-get install -y gksu

#sudo apt-get install -y tint2 xcompmgr feh tilda xfe network-manager network-manager-gnome arandr
apt-get install -y tint2 xcompmgr feh tilda xfe arandr

################################################
# Configure GUI
################################################
echo 'Setting up user config...'

touch /var/log/vagrantup.log
chown vagrant /var/log/vagrantup.log

cp -v $CONFIG_PATH/xinitrc /home/vagrant/.xinitrc
cp -v $CONFIG_PATH/bashprofile /home/vagrant/.bash_profile

mkdir -v /home/vagrant/.config >> /var/log/vagrantup.log
cp -v $CONFIG_PATH/tint2.conf /home/vagrant/.config/

mkdir -v /home/vagrant/.config/openbox >> /var/log/vagrantup.log
cp -v $CONFIG_PATH/openbox.autostart /home/vagrant/.config/openbox/autostart

mkdir -v /home/vagrant/.config/wallpaper >> /var/log/vagrantup.log
cp -v $CONFIG_PATH/samurai-background.png /home/vagrant/.config/wallpaper

echo "feh --bg-fill '/home/vagrant/.config/wallpaper/samurai-background.png'" >> /home/vagrant/.fehbg

cp $CONFIG_PATH/menu.xml /home/vagrant/.config/openbox/
cp $CONFIG_PATH/openbox_rc.xml /home/vagrant/.config/openbox/rc.xml

mkdir /home/vagrant/.config/tilda
cp $CONFIG_PATH/tilda_config_0 /home/vagrant/.config/tilda/config_0

cp -r $CONFIG_PATH/home/* /home/vagrant/

#chown -R samurai /home/samurai

#echo "xcompmgr -c &" >> /home/samurai/.config/openbox/autostart
#echo "tint2 &" >> /home/samurai/.config/openbox/autostart

echo 'samurai user environment all finished!'