#!/bin/sh

###################################################################
#: Date Created  : (October 25th, 2018)
#: Author        : Bob Gendler
#
#Add the user and the password as paramters in the script in jamf
#This must be an already FileVault enabled account
#
###################################################################

adminuser="${4}"
adminpass="${5}"

loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
userpassword=$(osascript -e 'display dialog "Please enter a your login password." default answer "" with icon stop buttons {"Cancel", "Continue"} default button "Continue" with hidden answer' | awk -F ':' '{print $3}')

if ! fdesetup list | grep "${adminuser}"; then 
    /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "User not found" -description "The ${adminuser} account is not FileVault enabled. That account must be enabled before continuing." -button1 "Ok" -defaultButton 1 -icon /System/Library/CoreServices/Problem\ Reporter.app/Contents/Resources/ProblemReporter.icns
    exit 0
fi

fdesetup remove -user "${loggedInUser}"

if [ "$?" != "0" ]; then
    /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "An Error Occured" -description "An error occured with your account and FileVault. Please contact your Tech Support." -button1 "Ok" -defaultButton 1 -icon /System/Library/CoreServices/Problem\ Reporter.app/Contents/Resources/ProblemReporter.icns
    echo "User not removed successfully from FileVault"
    exit 1
else
    echo "User successfully removed from FileVault"
fi

echo "${loggedInUser}" "${adminuser}" "${adminpass}" "${userpassword}"
echo "log_user 1" > /var/tmp/expectfile
echo 'spawn fdesetup add -usertoadd [lindex $argv 0] -user [lindex $argv 1]' >> /var/tmp/expectfile
echo 'expect ":"' >> /var/tmp/expectfile
echo 'send "[lindex $argv 2]\\r"' >> /var/tmp/expectfile
echo 'expect ":"' >> /var/tmp/expectfile
echo 'send "[lindex $argv 3]\\r"' >> /var/tmp/expectfile
echo 'interact' >> /var/tmp/expectfile

expect -f /var/tmp/expectfileexpectfile "${loggedInUser}" "${adminuser}" "${adminpass}" "${userpassword}"

rm /var/tmp/expectfileexpectfile

if fdesetup list | grep "${loggedInUser}"; then
    /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "FileVault User Added" -description "${loggedInUser} was successfully re-added to Filevault with the new password." -button1 "Ok" -defaultButton 1 -icon /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/FileVaultIcon.icns
else
    /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "An Error Occured" -description "An error occured with your account and FileVault. Please contact your Tech Support." -button1 "Ok" -defaultButton 1 -icon /System/Library/CoreServices/Problem\ Reporter.app/Contents/Resources/ProblemReporter.icns
fi

