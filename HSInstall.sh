#!/bin/sh

#This does a lot of checks to make sure there's all the right conditions to begin install High Sierra
#Do you have the right version of office? If not it will install the newest
#Do you have enough space?
#Are you already on High Sierra
#Is there enough power?
#Is it cached?

#Function used to call starting to install....plist supposedly makes an authenticated restart buuuut
StartInstall ()
{
	OfficeMajorVer=$(defaults read /Applications/Microsoft\ Word.app/Contents/Info.plist CFBundleShortVersionString | cut -c 1-2)
	OfficeMinorVer=$(defaults read /Applications/Microsoft\ Word.app/Contents/Info.plist CFBundleShortVersionString | cut -c 4-5)
	fileVaultStatus=$(fdesetup status | awk '{print $3}' | tr -d ".")
	
	if [ "$fileVaultStatus" = "On" ]; then
		
cat << EOF > /Library/LaunchAgents/com.apple.install.osinstallersetupd.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.apple.install.osinstallersetupd</string>
    <key>LimitLoadToSessionType</key>
    <string>Aqua</string>
    <key>MachServices</key>
    <dict>
        <key>com.apple.install.osinstallersetupd</key>
        <true/>
    </dict>
    <key>TimeOut</key>
    <integer>Aqua</integer>
    <key>OnDemand</key>
    <true/>
    <key>ProgramArguments</key>
    <array>
        <string>/Applications/Install macOS High Sierra.app/Contents/Frameworks/OSInstallerSetup.framework/Resources/osinstallersetupd</string>
    </array>
</dict>
</plist>
EOF
        getUser=$(ls -l /dev/console | awk '{ print $3 }')

        echo "running launchctl as $getUser"	
		chown root:wheel /Library/LaunchAgents/com.apple.install.osinstallersetupd.plist
		chmod 755 /Library/LaunchAgents/com.apple.install.osinstallersetupd.plist
		sudo -u $getUser launchctl load -w -F /Library/LaunchAgents/com.apple.install.osinstallersetupd.plist
		sudo -u $getUser launchctl start -w -F com.apple.install.osinstallersetupd
	fi

#IF Microsoft Office too old, then update it to compatibility with High Sierra
	if [ $OfficeMajorVer -lt 16 ]; then
	    if [ $OfficeMinorVer -lt 35 ]; then
            /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Microsoft Office needs updated" -description "The version of Microsoft Office installed on your computer is not compatible with macOS High Sierra. Microsoft Office will upgrade before continuing. This may add an additional 10 to 15 minutes to the upgrading process." -button1 "Ok" -defaultButton 1 -icon "/Applications/Install macOS High Sierra.app/Contents/Resources/ProductPageIcon.icns"
		    ps ax |  grep "/Applications/Microsoft Word.app" | awk '{print $1}' | xargs kill -9 2> /dev/null
            ps ax |  grep "/Applications/Microsoft Excel.app" | awk '{print $1}' | xargs kill -9 2> /dev/null
            ps ax |  grep "/Applications/Microsoft PowerPoint.app" | awk '{print $1}' | xargs kill -9 2> /dev/null
            ps ax |  grep "/Applications/Microsoft Outlook.app" | awk '{print $1}' | xargs kill -9 2> /dev/null
		    jamf policy -event MSOffice2016
        fi
    fi


#Dialog comes up and calls the starttoinstall command in the High Sierra Installer
	    /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Installing macOS High Sierra" -description "mac OS High Sierra will begin installing momentarily.

Please save all work NOW as all unsaved work will be LOST." -button1 "Ok" -icon "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/Sync.icns" -defaultButton 1 &
	    /Applications/Install\ macOS\ High\ Sierra.app/Contents/Resources/startosinstall --applicationpath "/Applications/Install macOS High Sierra.app" --agreetolicense
	    
		killall "Self Service"
		exit 0
}


OS=$(sw_vers -productVersion | cut -c 1-5)
#Checks to see if OS is on 10.13, if it is, it reports home witha  recon
if [ "$OS" = "10.13" ]; then
	/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "High Sierra Installed" -description "mac OS High Siera is already installed" -button1 "Ok" -icon "/Applications/Utilities/System Information.app/Contents/Resources/SystemLogo.tiff" -defaultButton 1 &
	echo "10.13 already installed"
	ps ax |  grep "/Applications/SAES Self Service.app" | awk '{print $1}' | xargs kill -9 2> /dev/null
	exit 0
fi

#Do you have enough storage?
#If not pop up message and let people know
StorageAvail=$(system_profiler SPStorageDataType | grep -A2 "Macintosh HD" | grep "Available:" | awk -F " " '{print $2}' | cut -d "." -f 1)

StorageAvail="${StorageAvail//[$'\t\r\n ']}"

echo "Computer has $StorageAvail space available"

if [ "$StorageAvail" -lt 10 ]; then
	jamf displayMessage -message "Your computer does not have enough space. You have only $(df -H / | tail -1 | awk '{print $4}') GB of space free. MacOS High Sierra requires at least 10 GB of free space available. If you need help making room, please visit the Technology Office."
	echo "Not enough storage space"
	exit 0
fi

#Is High Sierra even cached?
if [ ! -d "/Applications/Install macOS High Sierra.app" ]; then
	echo "not cached"
	/usr/local/bin/jamf policy -event highsierra &
	/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "High Sierra Not Cached" -description "mac OS High Sirra is not cached and is not yet ready to be installed, please check back soon." -button1 "Ok" -icon "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/Bonjour.icns" -defaultButton 1 &
	exit 0
fi

#Are you plugged in and if not, is there enough power
PluggedInYN=$(pmset -g ps | grep "Power" | cut -c 18- | tr -d "'")

if [ "$PluggedInYN" = "AC Power" ]; then
	echo "plugged in"
	#if every condition is met call the StartInstall function and begin install
	StartInstall

else
	BatteryPercentage=$(pmset -g ps | tail -1 | awk -F ";" '{print $1}' | awk -F "\t" '{print $2}' | tr -d "%")
	if [ $BatteryPercentage -ge 50 ]; then
    echo "laptop over 50% power" 
    #if every condition is met call the StartInstall function and begin install
    StartInstall
    
	else
		jamf displayMessage -message "Please plug your laptop in while installing. You do not have enough power to install macOS Sierra. You have $BatteryPercentage% power left" 
		echo "not enough juice"
		exit 0
	fi
fi
