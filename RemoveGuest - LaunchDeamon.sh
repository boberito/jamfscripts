#!/bin/sh

mkdir -p /usr/local/saes
#touch /usr/local/saes/guestResults.txt

##################
##CREATE SCRIPT###
##################
cat << EOF > /usr/local/saes/removeGuest.sh
#!/bin/bash

#set interface name and network you're hunting for
interfaceName="Wi-Fi"
networkName="attwifi"

Adapter=\$(networksetup -listallhardwareports | grep -A 1 "\$interfaceName" | grep Device | awk '{print \$2}')

if networksetup -listpreferredwirelessnetworks \$Adapter | grep "\$networkName"; then
	echo "Guest Found"
	ConnectedtoGuest=\$(networksetup -getairportnetwork \$Adapter | awk -F ":" '{ print \$2 }' | cut -c 2-)
	if [ "\$ConnectedtoGuest" == "\$networkName" ]; then
			#Gotta disconnect first to remove it
			networksetup -setairportpower \$Adapter off
			networksetup -removepreferredwirelessnetwork \$Adapter "\$networkName"
			networksetup -setairportpower \$Adapter on
			#echo "Guest Connected and Found and Removed" >> /usr/local/saes/guestResults.txt
	else
			networksetup -removepreferredwirelessnetwork \$Adapter "\$networkName"
			#echo "Guest Found and Removed" >> /usr/local/saes/guestResults.txt
	fi
fi

EOF

########################
##CREATE LAUNCHDAEMON###
########################

cat << EOF > /Library/LaunchDaemons/com.saes.removeguest.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.saes.removeguest2</string>
	<key>ProgramArguments</key>
	<array>
		<string>sh</string>
		<string>-c</string>
		<string>/usr/local/saes/removeGuest.sh</string>
	</array>
	<key>WatchPaths</key>
	<array>
		<string>/Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist</string>
	</array>
</dict>
</plist>

EOF

chown rgendler:wheel /usr/local/saes/removeGuest.sh
chmod 755 /usr/local/saes/removeGuest.sh

chown root:wheel /Library/LaunchDaemons/com.saes.removeguest.plist
chmod 644 /Library/LaunchDaemons/com.saes.removeguest.plist

launchctl load -w /Library/LaunchDaemons/com.saes.removeguest.plist