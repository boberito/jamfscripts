#!/bin/bash

#Watch the ~/Library/Preferences/com.apple.security.ctkd-db.plist for changes
#If a card is inserted, run the script.
#Auto creates identity preferences for specificed services on card insertion

loggedInUser="$(/usr/sbin/scutil <<< "show State:/Users/ConsoleUser" | awk -F': ' '/[[:space:]]+Name[[:space:]]:/ { if ( $2 != "loginwindow" ) { print $2 }} ' )"
System_UUID=$(system_profiler SPHardwareDataType 2>&1 | grep "Hardware UUID" | cut -d: -f2|sed -e 's/^ *//g')

########################
###CREATE LAUNCHAGENT###
########################
USERS=$(dscl . list /users shell 2>&1 | grep -v /usr/bin/false | grep -v "_mbsetupuser" |grep -v "^root" | grep -v 'Guest' | awk '{print $1}')


for USER in $USERS; do
if [ ! -d /Users/$USER/Library/LaunchAgents ]; then
	mkdir /Users/$USER/Library/LaunchAgents
    chmod 755 /Users/$USER/Library/LaunchAgents
    chown $USER /Users/$USER/Library/LaunchAgents
fi


cat << EOF > /Users/$USER/Library/LaunchAgents/com.YourOrg.prefident.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.YourOrg.prefident</string>
	<key>ProgramArguments</key>
	<array>
		<string>bash</string>
		<string>/var/tools/identpref.bash</string>
	</array>
	<key>WatchPaths</key>
	<array>
		<string>/Users/$USER/Library/Preferences/com.apple.security.ctkd-db.plist</string>
	</array>
</dict>
</plist>

EOF


chown $USER /Users/$USER/Library/LaunchAgents/com.YourOrg.prefident.plist
chmod 644 /Users/$USER/Library/LaunchAgents/com.YourOrg.prefident.plist
done
##################
##CREATE SCRIPT###
##################
cat << EOF > var/tools/identpref.bash
#!/bin/bash
cardPresent=\$(sc_auth identities)
if [ "\$cardPresent" != "" ]; then
loggedInUser="\$(/usr/sbin/scutil <<< "show State:/Users/ConsoleUser" | awk -F': ' '/[[:space:]]+Name[[:space:]]:/ { if ( \$2 != "loginwindow" ) { print \$2 }} ' )"

sha1=\$(/usr/bin/security export-smartcard -t certs | grep "Certificate For PIV Authentication" -A 5 | grep sha1 | head -n1 | cut -d'<' -f2 | sed "s/[ >]//g")

/usr/bin/security set-identity-preference -c "\$loggedInUser" -s 'identprefadded whatever.com' -Z "\$sha1"
fi
EOF

chown root:wheel var/tools/identpref.bash
chmod 755 var/tools/identpref.bash

sudo -u $loggedInUser launchctl load -w /Users/$loggedInUser/Library/LaunchAgents/com.YourOrg.prefident.plist
