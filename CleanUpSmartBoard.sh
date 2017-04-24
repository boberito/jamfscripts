#!/bin/sh

# CleanUp.sh
# SMART TS Tools

killall -9 "Marker"
killall -9 "Aware"
killall -9 "SMART Ink"
killall -9 "FloatingTools"
killall -9 "SMARTBoardService"
killall -9 "SMART Board Tools"
killall -9 "Board Tools"
killall -9 "Response Desktop Menu"
killall -9 "Desktop Menu"
killall -9 "Teacher Tools"
killall -9 "ResponseSoftwareService"
killall -9 "ResponseHardwareService"
killall -9 "Notebook"
killall -9 "Recorder"
killall -9 "Welcome"
killall -9 "SMART Board Control Panel"
killall -9 "SMART Settings"
killall -9 "SMART Product Update"
killall -9 "Install Manager"
killall -9 "Screen Capture"
killall -9 "SMARTFirmwareUpdater"
killall -9 "VantageService"

#Remove Preferences
rm -rf /Library/Preferences/com.smart*
rm -rf /Library/Preferences/.com.smart*
rm -rf /Library/Preferences/FLEXnet\ Publisher
rm -rf /Users/Shared/Library/Preferences/com.smart*
rm -rf /Users/Shared/Library/Preferences/.com.smart*
rm -rf ~/Library/Preferences/com.smart*
rm -rf ~/Library/Preferences/SmartSync

#Remove Receipts
rm -rf /Library/Receipts/Gallery\ Setup.pkg
rm -rf /Library/Receipts/SMART*
rm -rf /Library/Receipts/Notebook*
rm -rf /Library/Receipts/Adobe*
rm -rf /Library/Receipts/Senteo*

#Remove Main Applications
rm -rf /Applications/SMART*
rm -rf /Applications/Notebook*
rm -rf /Applications/Response*
rm -rf /Applications/Senteo*
rm -rf /Applications/Gallery*

#Remove Remaining files
rm -rf /Library/Application\ Support/SMART*
rm -rf /Library/Application\ Support/FLEXnet\ Publisher
rm -rf /Library/Frameworks/com.smart*
rm -rf /Library/Frameworks/Senteo*
rm -rf /Library/Frameworks/WebInterface*
rm -rf ~/Library/Application\ Support/SMART*
rm -rf ~/Library/Application\ Support/MathType\ \<MajVersion\>\ Toolbar.eql
rm -rf /System/Library/Extensions/SMART*
rm -rf /System/Library/Extensions/Senteo.kext
rm -rf ~/Documents/SMART*
rm -rf ~/Documents/LabVIEW*
rm -rf ~/Documents/My\ Notebook\ Content

#Remove Temp files and folders
rm -rf ~/Library/Caches/Teacher\ Tools
rm -rf ~/Library/Caches/TemporaryItems/SMART*
rm -rf ~/Library/Caches/com.smarttech*
rm -rf ~/Library/Caches/TemporaryItems/NBK*
rm -rf ~/Library/Caches/Notebook*
rm -rf /Library/Caches/Gallery\ Setup
rm -rf ~/Library/Caches/Gallery\ Setup
rm -rf ~/Library/Caches/Gallery*
rm -rf ~/.NBadminMode
rm -rf ~/MySMARTContent

#Remove Additional
rm -rf /private/tmp/SMARTBoardTools*
rm -rf /Library/Caches/com.smartech.*
rm -rf /var/root/Library/Preferences/com.smarttech.*
rm -rf /private/var/root/Library/Preferences/com.smarttech.*
rm -rf /Users/Shared/Library/Preferences/com.smarttech.*
rm -rf /Library/StartupItems/Senteo*
rm -rf /Library/Receipts/Senteo*
rm -rf /Library/StartupItems/ResponseHardwareService
rm -rf /Library/StartupItems/Senteo*
rm -rf /Senteo*
rm -rf /System/Library/PreferencePanes/Ink.prefPane
rm -rf /Library/PreferencePanes/SMART\ Board.prefPane
rm -rf /etc/launchd.conf
rm -rf ~/Library/Application\ Support/SMART*
rm -rf /~/.config/SMART*
rm -rf /Library/StartupItems/SMART*
rm -rf /SMART*
rm -rf /Library/Frameworks/SMART*
rm -rf /Library/Logs/SMART*
rm -rf /System/Library/Extensions/Response.kext


#OSX 10.6 new Receipt removal
pkgutil --pkgs="com.smarttech.*" | while read line; do pkgutil --forget "$line"; done

