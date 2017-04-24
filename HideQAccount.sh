#!/bin/sh 

#delete current user's desktop items 
#WARNING, THIS WILL DELETE EVERYTHING 

sudo defaults write /Library/Preferences/com.apple.loginwindow HiddenUsersList -array-add q
