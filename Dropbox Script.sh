#!/bin/bash

mkdir /tmp/getmacapps_temp
cd /tmp/getmacapps_temp

# Installing Dropbox
curl -L -o Dropbox.dmg "https://www.dropbox.com/download?plat=mac"
hdiutil mount -nobrowse Dropbox.dmg
rsync -vaz  "/Volumes/Dropbox Installer/Dropbox.app/" /Applications/Dropbox.app
hdiutil unmount "/Volumes/Dropbox Installer"
rm Dropbox.dmg
