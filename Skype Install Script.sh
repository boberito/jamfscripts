#!/bin/bash

mkdir /tmp/getmacapps_temp
cd /tmp/getmacapps_temp

# Installing Skype
curl -L -O "http://www.skype.com/go/getskype-macosx.dmg"
hdiutil mount -nobrowse getskype-macosx.dmg
rsync -vaz /Volumes/Skype/Skype.app/ /Applications/Skype.app
hdiutil unmount "/Volumes/Skype"
rm getskype-macosx.dmg

#From GetMacApps.com