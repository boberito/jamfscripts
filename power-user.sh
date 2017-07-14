#!/bin/sh

spctl --master-disable 

#system preferences
security authorizationdb write system.preferences allow
security authorizationdb write system.preferences.network allow
security authorizationdb write system.preferences.accessibility allow
security authorizationdb write system.preferences.energysaver allow
security authorizationdb write system.preferences.printing allow
security authorizationdb write system.preferences.datetime allow
security authorizationdb write system.preferences.timemachine allow
security authorizationdb write system.preferences.network allow
security authorizationdb write system.preferences.security allow
security authorizationdb write system.services.systemconfiguration.network allow


#Printing
security authorizationdb write system.preferences.printing allow
security authorizationdb write system.printingmanager allow
security authorizationdb write system.print.admin allow
security authorizationdb write system.print.operator allow


#potential force restart and shutdown if other users logged in
security authorizationdb write system.restart allow
security authorizationdb write system.shutdown allow

#App store
security authorizationdb write system.install.app-store-software allow

#DVD Player
security authorizationdb write system.device.dvd.setregion allow
security authorizationdb write system.device.dvd.setregion.chage allow
security authorizationdb write system.device.dvd.setregion.initial allow
security authorizationdb write system.device.dvd.setregion.change.comment allow
security authorizationdb write system.device.dvd.setregion.change.change allow
security authorizationdb write system.device.dvd.setregion.initial.class allow
security authorizationdb write system.device.dvd.setregion.change.class allow
security authorizationdb write system.device.dvd.setregion.change.comment allow
security authorizationdb write system.device.dvd.setregion.change.group allow
security authorizationdb write system.device.dvd.setregion.change.group allow
security authorizationdb write system.device.dvd.setregion.change.shared allow

#Groups needed to be in for things to unlock
USERNAME=`who |grep console| awk '{print $1}'`

dseditgroup -o edit -a $USERNAME -T group _appstore
dseditgroup -o edit -a $USERNAME -T group lpadmin

/usr/libexec/airportd prefs RequireAdminNetworkChange=NO RequireAdminIBSS=NO

## Unload locationd
launchctl unload /System/Library/LaunchDaemons/com.apple.locationd.plist

## Write enabled value to locationd plist
defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -int 1

## Fix Permissions for the locationd folder
chown -R _locationd:_locationd /var/db/locationd

## Reload locationd
launchctl load /System/Library/LaunchDaemons/com.apple.locationd.plist

exit 0
