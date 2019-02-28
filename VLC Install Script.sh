#!/bin/bash

mkdir /tmp/downloads
cd /tmp/downloads

# Installing VLC Player
CurrentVLC=$(curl -s "http://get.videolan.org/vlc/last/macosx/" | grep .dmg | awk -F '"' '/.dmg/{print $2}' | grep -v "dmg.")

curl -s -L -o vlc.dmg http://get.videolan.org/vlc/last/macosx/$CurrentVLC

hdiutil mount -quiet -nobrowse vlc.dmg -mountpoint /Volumes/vlc
rsync -vazq /Volumes/vlc/VLC.app/ /Applications/VLC.app
hdiutil unmount "/Volumes/vlc"
rm vlc.dmg
rm -rf /tmp/downloads
