#!/bin/sh

#Sets up a script and creates a launchdeamon that watches com.apple.airport.preferences.plist
#This changes whenever you join a network. If the Guest network is joined, then remove it and bop them off of it


##################
##CREATE SCRIPT###
##################
cat << EOF > /usr/local/removeGuest.sh
#!/bin/bash

#set interface name and network you're hunting for
interfaceName="Wi-Fi"
networkName="GUEST"

Adapter=\$(networksetup -listallhardwareports | grep -A 1 "\$interfaceName" | grep Device | awk '{print \$2}')

if networksetup -listpreferredwirelessnetworks \$Adapter | grep "\$networkName"; then
	echo "Guest Found"
	ConnectedtoGuest=\$(networksetup -getairportnetwork \$Adapter | awk -F ":" '{ print \$2 }' | cut -c 2-)
	if [ "\$ConnectedtoGuest" == "\$networkName" ]; then
			#Gotta disconnect first to remove it
			networksetup -setairportpower \$Adapter off
			networksetup -removepreferredwirelessnetwork \$Adapter "\$networkName"
			networksetup -setairportpower \$Adapter on
			
	else
			networksetup -removepreferredwirelessnetwork \$Adapter "\$networkName"
			
	fi
fi

EOF

########################
##CREATE LAUNCHDAEMON###
########################

cat << EOF > /Library/LaunchDaemons/com.YOURCOMPANY.removeguest.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.YOURCOMPANY.removeguest2</string>
	<key>ProgramArguments</key>
	<array>
		<string>sh</string>
		<string>-c</string>
		<string>/usr/local/removeGuest.sh</string>
	</array>
	<key>WatchPaths</key>
	<array>
		<string>/Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist</string>
	</array>
</dict>
</plist>

EOF

chown rgendler:wheel /usr/local/removeGuest.sh
chmod 755 /usr/local/removeGuest.sh

chown root:wheel /Library/LaunchDaemons/com.YOURCOMPANY.removeguest.plist
chmod 644 /Library/LaunchDaemons/com.YOURCOMPANY.removeguest.plist

launchctl load -w /Library/LaunchDaemons/com.YOURCOMPANY.removeguest.plist
