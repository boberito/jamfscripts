#!/bin/sh

OS=$(sw_vers -productVersion | cut -c 1-5)

if [ "$OS" = "10.12" ]; then
	/usr/local/bin/jamf recon
	/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Sierra Installed" -description "mac OS Siera is already installed" -button1 "Ok" -icon "/Applications/Utilities/System Information.app/Contents/Resources/SystemLogo.tiff" -defaultButton 1 &
	echo "10.12 already installed"
	ps ax |  grep "/Applications/SAES Self Service.app" | awk '{print $1}' | xargs kill -9 2> /dev/null
	exit 0
fi


StorageAvail=$(df -H / | tail -1 | awk '{print $4}' | tr -d "G")

if [ $StorageAvail -lt 10 ]; then
	jamf displayMessage -message "Your computer does not have enough space. You have only $(df -H / | tail -1 | awk '{print $4}') GB of space free. If you need help making room, please visit the Technology Office."
	echo "Not enough storage space"
	exit 0
fi


if [ ! -d "/Applications/Install macOS Sierra.app" ]; then
	/usr/local/bin/jamf policy -event sierraAppCache &
	/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Sierra Not Cached" -description "mac OS Sirra was not cached, please check back soon." -button1 "Ok" -icon "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/Bonjour.icns" -defaultButton 1 &
	echo "not cached"
	ps ax |  grep "/Applications/SAES Self Service.app" | awk '{print $1}' | xargs kill -9 2> /dev/null
	exit 0
fi


PluggedInYN=$(pmset -g ps | grep "Power" | cut -c 18- | tr -d "'")
if [ "$PluggedInYN" = "AC Power" ]; then
        /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Installing macOS Sierra" -description "mac OS Sierra will begin installing momentarily.

Please save all work NOW as all unsaved work will be LOST." -button1 "Ok" -icon "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/Sync.icns" -defaultButton 1 &
	    /Applications/Install\ macOS\ Sierra.app/Contents/Resources/startosinstall --applicationpath "/Applications/Install macOS Sierra.app" --volume $1 --rebootdelay 30 --nointeraction
	    echo "plugged in"
	    killall "Self Service"
	    exit 0
else
	BatteryPercentage=$(pmset -g ps | tail -1 | awk -F ";" '{print $1}' | awk -F "\t" '{print $2}' | tr -d "%")
	if [ $BatteryPercentage -ge 50 ]; then
	    /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Installing macOS Sierra" -description "mac OS Sierra will begin installing momentarily.

Please save all work NOW as all unsaved work will be LOST." -button1 "Ok" -icon "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/Sync.icns" -defaultButton 1 &
	    /Applications/Install\ macOS\ Sierra.app/Contents/Resources/startosinstall --applicationpath "/Applications/Install macOS Sierra.app" --volume $1 --rebootdelay 30 --nointeraction
	    echo "laptop over 50% power"
		killall "Self Service"
		exit 0
	else
		jamf displayMessage -message "Please plug your laptop in while installing. You do not have enough power to install macOS Sierra. You have $BatteryPercentage% power left" 
		echo "not enough juice"
		exit 0
	fi
fi