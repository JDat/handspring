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
