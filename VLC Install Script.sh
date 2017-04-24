#!/bin/bash

mkdir /tmp/downloads
cd /tmp/downloads

# Installing VLC Player
CurrentVLC=$(curl "http://get.videolan.org/vlc/last/macosx/" | grep .dmg | grep -v webplugin | grep -v md5 | grep -v sha1 | grep -v sha256 | awk '{print $2}' | awk -F ">" '{print $2}' | tr -d "</a")

curl -L -o vlc.dmg http://get.videolan.org/vlc/last/macosx/$CurrentVLC

hdiutil mount -nobrowse vlc.dmg -mountpoint /Volumes/vlc
rsync -vaz /Volumes/vlc/VLC.app/ /Applications/VLC.app
hdiutil unmount "/Volumes/vlc"
rm vlc.dmg
rm -rf /tmp/downloads

#Inspired from GetMacApps.com
