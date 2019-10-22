#!/bin/bash

#Variables that need set
#$4 set as "appleupdates" if you want apple softwareupdate ran.
#$5 is days to defer
prefLocation="/var/info/Reboot.plist"
boundName=$(dsconfigad -show | awk '/Computer Account/{print $NF}' | sed 's/$$//')
daysToDefer="$5"



##########REBOOT LATER FUNCTION#################
function rebootLater {
    
    installedDate=$(/usr/libexec/PlistBuddy -c "print :installedDate" "${prefLocation}")
    todayDate=$(date "+%m-%d-%Y")
    declare -i dateDiff
    dateDiff=$(date -j -f "%m-%d-%Y" "$todayDate" "+%s")-$(date -j -f "%m-%d-%Y" "$installedDate" "+%s")
    dateDiff=dateDiff/86400
    
    DaysFromNow=$(/usr/libexec/PlistBuddy -c "print :DaysFromNow" "${prefLocation}")
    declare -i DaysLeftToDefer
    DaysLeftToDefer=$(/usr/libexec/PlistBuddy -c "print :DaysLeftToDefer" "${prefLocation}")
    
    description="An update to your computer was installed on ${installedDate}, ${dateDiff} days ago. 
    
Your computer requires a restart. It will be restarted in ${DaysLeftToDefer} days"

	title="Restart required"  

	heading="Your computer will restart on ${DaysFromNow}"

	installationdelay=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "${title}" -heading "${heading}" -description "${description}" -icon "/System/Library/CoreServices/Install Command Line Developer Tools.app/Contents/Resources/SoftwareUpdate.icns" -button1 "Ok" -button2 "Later" -defaultButton 1 -showDelayOptions "0, 60, 300, 900" )

	if [ "${installationdelay}" = "2" ]; then
        #Subtract a day left from the preference file.
        DaysLeftToDefer=$((DaysLeftToDefer-1))
    	/usr/libexec/PlistBuddy -c "set :DaysLeftToDefer ${DaysLeftToDefer}" "${prefLocation}"

    else
        #if NOW is selected or dialog box timed out
        if [[ $installationdelay -eq 1 ]];then
            jamf reboot -startTimerImmediately -background
        else
        #Do this in X minutes. Dialog gives you seconds, gotta convert to minutes and strip off the exit code.
            declare -i delayInMin
            size=${#installationdelay}
            delayInMin=${installationdelay:0:size-1}/60
            rm -f ${prefLocation}
            jamf reboot -minutes "${delayInMin}" -startTimerImmediately -background
        fi
	fi
}

##########REBOOT NOW FUNCTION#################
function rebootNow {
    
    installedDate=$(/usr/libexec/PlistBuddy -c "print :installedDate" "${prefLocation}")
    todayDate=$(date "+%m-%d-%Y")
    declare -i dateDiff
    dateDiff=$(date -j -f "%m-%d-%Y" "$todayDate" "+%s")-$(date -j -f "%m-%d-%Y" "$installedDate" "+%s")
    dateDiff=dateDiff/86400
    
    description="An update to your computer was installed on ${installedDate}, ${dateDiff} days ago. 
    
Your computer requires a restart. Please save all work as your computer will be restarted shortly"

	title="Restart required"  

	heading="Your computer will restart shortly"

	installationdelay=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "${title}" -heading "${heading}" -description "${description}" -icon "/System/Library/CoreServices/Install Command Line Developer Tools.app/Contents/Resources/SoftwareUpdate.icns" -button1 "Ok" -defaultButton 1 -showDelayOptions "0, 60, 300, 900" -timeout 30 -countdown)
    #if NOW is selected or dialog box timed out
    if [[ $installationdelay -eq 1 ]]; then
        rm -f ${prefLocation}
        jamf reboot -background
    else
    #Do this in X minutes. Dialog gives you seconds, gotta convert to minutes and strip off the exit code.
        declare -i delayInMin
        size=${#installationdelay}
        delayInMin=${installationdelay:0:size-1}/60
        rm -f ${prefLocation}
        jamf reboot -minutes "${delayInMin}" -startTimerImmediately -background
    fi
}

#####The Main Portion#####

#if the plist doesnt exist, create it
if [ ! -f "${prefLocation}" ]; then
    
    #Check Apple Software Updates
    if [[ "$4" = "appleupdates" ]]; then
        rebootRequired=$(softwareupdate -l | grep -o restart 2>&1)
        if [[ "$rebootRequired" =~ "restart" ]]; then
            echo "Apple Software Update requires a reboot"
            softwareupdate -i -a
        else
            echo "Apple Software Update does not require a reboot"
            softwareupdate -i -a
            exit 0
        fi
    fi

    DaysFromNow=$(date -v +${daysToDefer}d "+%m-%d-%Y")
    installedDate=$(date "+%m-%d-%Y")
    /usr/libexec/PlistBuddy -c "add :installedDate string ${installedDate}" "${prefLocation}" &> /dev/null
    /usr/libexec/PlistBuddy -c "add :DaysFromNow string ${DaysFromNow}" "${prefLocation}"
    /usr/libexec/PlistBuddy -c "add :DaysLeftToDefer string ${daysToDefer}" "${prefLocation}"
    jamf recon&

#if it does exist, then we must have an update installed
else
	
    loggedInUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
	if [  -z "$loggedInUser" ]; then
		echo "Nobody logged in, here we go"
		jamf reboot -background
   	
	else
    
	    declare -i dateDiff
    	installedDate=$(/usr/libexec/PlistBuddy -c "print :installedDate" "${prefLocation}")
	    todayDate=$(date "+%m-%d-%Y")
    	DaysFromNow=$(/usr/libexec/PlistBuddy -c "print :DaysFromNow" "${prefLocation}")
	    dateDiff=$(date -j -f "%m-%d-%Y" "$todayDate" "+%s")-$(date -j -f "%m-%d-%Y" "$installedDate" "+%s")
    	dateDiff=dateDiff/86400
	    DaysLeftToDefer=$(/usr/libexec/PlistBuddy -c "print :DaysLeftToDefer" "${prefLocation}")
    
    	if [[ $dateDiff -ge $daysToDefer ]] || [[ $DaysLeftToDefer -eq 0 ]]; then
        	rebootNow
	    else
    	    rebootLater
	    fi
	fi
fi
