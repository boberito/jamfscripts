#!/bin/sh

mkdir /tmp/getmacapps_temp
cd /tmp/getmacapps_temp

curl -L -o googledrive.dmg https://dl.google.com/drive/installgoogledrive.dmg

hdiutil mount googledrive.dmg -nobrowse -mountpoint "/Volumes/Install Google Drive"
cp -Rp /Volumes/Install\ Google\ Drive/Google\ Drive.app /Applications/Google\ Drive.app
hdiutil unmount "/Volumes/Install Google Drive"
rm googledrive.dmg
killall Finder
open "/Applications/Google Drive.app" &

# CurrentUser=`ls -l /dev/console | awk '{ print $3 }'`
# dscl . -append /Groups/admin GroupMembership $CurrentUser
# open "/Applications/Google Drive.app"/
# sleep 180
# dscl . -delete /Groups/admin GroupMembership $CurrentUser
