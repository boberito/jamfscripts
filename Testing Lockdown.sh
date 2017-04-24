#!/bin/sh

/usr/bin/profiles -I -F "/var/tmp/Testing - Lockdown.mobileconfig"
mv /System/Library/Services/AppleSpell.service/ /System/Library/Services/AppleSpell.service.disabled
killall AppleSpell
/Applications/TextEdit.app/Contents/MacOS/TextEdit
killall Dock