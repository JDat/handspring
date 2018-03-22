#!/bin/bash

# This script will create udev rule in /etc/udev/rules.d
# and autosync script un /usr/local/bin
# for current user
# As result by pressing hotsync button on cradle
# or launching hotsync app palm device will make
# sync with linux jpilot app
# Please close jpilot application before syncing
#
# udev rule will make symlink to /dev/pilot
# for second ttyUSBx device
# and call shell script for sync

# TODO:
# *) Check for installed jpilot tools
# if no jpilot then abort install
# 
# *) Automatically change in .jpilot/jpilot.rc 
# port string to following: port /dev/pilot
#
# *) Handle screnario more correctly when
# pilot user app is opened
#
# *) schedule (once per day, week etc) full backup
# Righ now full backup is executed every time
# and sync is more slow


# script does following things
# check for root
# if not root then exit
# create udev rule in /etc/udev/rules.d
# create sync script /usr/local # need some minor fix
# set permissions for files
# add user to dialout
# reload udev rules

#not complete
#change port in jPolot preferences manualy /dev/pilot to for now

#check for root
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

rules_path="/etc/udev/rules.d"
rules_str="SUBSYSTEM==\"tty\", DRIVERS==\"visor\", MODE=\"0660\",  GROUP=\"dialout\", SYMLINK=\"pilot\", RUN=\"$SHELL /usr/local/bin/palm-autosync.sh\""

script_path="/usr/local/bin"
sync_script_str="#!$SHELL
#ps cax | grep jpilot > /dev/null
#if [ \$? -eq 0 ]; then
#  echo \"Process is running.\"
#else
  cd $HOME
  killall jpilot
  killall jpilot-sync
  jpilot-sync -b -p /dev/pilot
  chown -R $SUDO_USER .jpilot
#fi
"
#create udev rule
echo "$rules_str" > $rules_path/80-palm-hotsync.rules

echo "$sync_script_str" > $script_path/palm-autosync.sh

#set permissions
chmod 644 $rules_path/80-palm-hotsync.rules
#create sync script
chmod 755 $script_path/palm-autosync.sh

#add user to dialout
adduser $SUDO_USER dialout

#reload udev rules
udevadm control --reload-rules && udevadm trigger

# This is under development
# I am planning to automatically change in
# .jpilot/jpilot.rc port string to following:
#  port /dev/pilot

#change port in jPolot preferences
#from abc to XYZ in file .jpilot/jpilot.rc
#sed -i -e 's/abc/XYZ/g' /tmp/file.txt
#while read a ; do echo ${a//abc/XYZ} ; done < /tmp/file.txt > /tmp/file.txt.t ; mv /tmp/file.txt{.t,}

#debug
#chmod 777 80-palm-hotsync.rules
#chmod 777 palm-autosync.sh
