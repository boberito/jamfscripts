#!/bin/sh

getUser=`ls -l /dev/console | awk '{ print $3 }'`
defaults write /Users/$getUser/Library/Preferences/com.apple.dashboard mcx-disabled -boolean NO
sudo -u $getUser killall Dock
