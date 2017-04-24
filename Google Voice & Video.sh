#!/bin/sh

mkdir /tmp/downloads
cd /tmp/downloads



curl -O https://dl.google.com/googletalk/googletalkplugin/GoogleVoiceAndVideoSetup.dmg


hdiutil attach GoogleVoiceAndVideoSetup.dmg -nobrowse -noverify -noautoopen


installer -dumplog -verbose -pkg /Volumes/GoogleVoiceAndVideoAccelSetup*/Google\ Voice\ and\ Video.pkg -target "/"


hdiutil eject -force /Volumes/GoogleVoiceAndVideo*


rm -rf /tmp/downloads/GoogleVoiceAndVideoSetup.dmg
