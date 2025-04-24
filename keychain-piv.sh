#!/bin/bash

fvstatus=$(fdesetup status)

if [[ "$fvstatus" == "FileVault is On." ]]; then
echo "FV ON"
else
echo "FV OFF"
	/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Filevault Off" -description "FileVault is NOT enabled. No synchronization for smartcard is required." -button1 "Ok" -defaultButton 1 -icon /System/Library/CoreServices/Problem\ Reporter.app/Contents/Resources/ProblemReporter.icns
	exit 0
fi

GUIUSER="$(/usr/sbin/scutil <<< "show State:/Users/ConsoleUser" | awk -F': ' '/[[:space:]]+Name[[:space:]]:/ { if ( $2 != "loginwindow" ) { print $2 }}' )"
echo $GUIUSER
GUIUID=$(id -u $GUIUSER)
echo $GUIUID
hash=$(launchctl asuser $GUIUID sc_auth identities | awk '/ PIV /{print $1}')
echo $hash
if [ -z $hash ]; then
	echo "No PIV detected"
	/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "No PIV Detected" -description "No smartcard detected. Please try again.

If problems continue, try these 2 steps.
    1. Take the card out and re-insert
    2. Unplug the reader and plug back in
Then try again." -button1 "Ok" -defaultButton 1 -icon /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericNetworkIcon.icns
    
    exit 1
fi
sc_auth filevault -o disable -u $GUIUSER
echo $?
sudo -u $GUIUSER launchctl asuser $GUIUID sc_auth filevault -o enable -u $GUIUSER -h $hash
echo $?

fvstatus="$(sc_auth filevault -o status -u $GUIUSER)" 

if [[ "$fvstatus" =~ "not present" ]]; then 
	echo "FAIL"
    if [[ "$(arch)" == "arm64" ]]; then
		/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Failure" -description "Filevault and the Keychain failed to update." -button1 "Ok" -defaultButton 1 -icon /System/Library/CoreServices/Problem\ Reporter.app/Contents/Resources/ProblemReporter.icns    

	else
		/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Failure" -description "The Keychain failed to update. " -button1 "Ok" -defaultButton 1 -icon /System/Library/CoreServices/Problem\ Reporter.app/Contents/Resources/ProblemReporter.icns    
	fi    
else
	/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Success" -description 'Everything has updated successfully!' -button1 "Ok" -defaultButton 1 -icon '/System/Applications/Utilities/Keychain Access.app/Contents/Resources/AppIcon.icns'

	echo "SUCCESS"
fi
diskutil apfs updatePreboot /
domain=$(launchctl asuser $GUIUID app-sso -l | awk -F '<string>|</string>' '{print $2}' | xargs)
launchctl asuser $GUIUID app-sso -d $domain
killall AppSSOAgent
