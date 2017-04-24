#!/bin/sh

OSVers=$(sw_vers | grep "ProductVersion" | cut -d ':' -f 2 | awk -F "." '{print $2}')
if [ $OSVers -lt 12 ]; then 

	sierraDialog=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Install macOS Sierra" -heading "Your computer is overdue for a major system upgrade." -description "Installation time could exceed one hour, and your computer will NOT be usable during the process. Please connect your power cord, and do not close the lid of the laptop.

You may postpone installation and upgrade later through Self Service." -button1 "Install Now" -button2 "Postpone" -defaultButton 2 -icon "/usr/local/saes/saesshield.png" -lockHUD)

	if [ $sierraDialog != 0 ]; then
		echo "Try again later..."
	else
		echo "Installing Sierra..."
		jamf policy -event SierrraInstall
	fi
else
	echo $(sw_vers | grep "ProductVersion")
	jamf recon
fi