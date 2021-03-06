#!/bin/sh
## postinstall

pathToScript=$0
pathToPackage=$1
targetLocation=$2
targetVolume=$3

getUser=`ls -l /dev/console | awk '{ print $3 }'`

RealName=`dscl '/Active Directory/ACADEMIC/All Domains' -read /Users/$getUser RealName | grep -v ":"`
RealRealName=`echo $RealName | awk '{ print $1 " " $3}'`
FirstLastInitial=`echo $RealName | awk '{ print $1 }' | cut -c 1 ; echo $RealName | awk '{ print $3 }' | cut -c 1` 
FirstLastInitial=`echo $FirstLastInitial | cut -c 1,3`


#mv "/private/var/tmp/Office\ Temp/Application\ Support/Microsoft" "/Users/$getUser/Library/Application Support/"
#mv "/private/var/tmp/Office Temp/Preferences"/* "/Users/$getUser/Library/Preferences/"
#mv "/private/var/tmp/Office Temp/Documents/Microsoft User Data" "/Users/$getUser/Documents/" 


defaults write com.microsoft.office "14\UserInfo\UserInitials" -string "$FirstLastInitial"
defaults write com.microsoft.office "14\UserInfo\UserName" -string "$RealRealName"
defaults write "/Users/$getUser/Library/Application Support/Microsoft/Office/MeContact.plist" "First Name" -string `echo $RealName | awk '{ print $1}'`
#defaults write "/Users/$getUser/Library/Application Support/Microsoft/Office/MeContact.plist" "Last Name" -string `echo $RealName | awk '{ print $3}'`
defaults write "/Users/$getUser/Library/Application Support/Microsoft/Office/MeContact.plist" Name -string "$RealRealName"
defaults write "/Users/$getUser/Library/Application Support/Microsoft/Office/MeContact.plist" Initials -string "$FirstLastInitial"
defaults write "/Users/$getUser/Library/Application Support/Microsoft/Office/MeContact.plist" "Business Company" -string "St. Andrew's Episcopal School"

#chown -R $getUser /Users/$getUser



exit 0		## Success
exit 1		## Failure
