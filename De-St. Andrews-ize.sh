#!/bin/sh

nvram -d boot-args
nvram -c
/usr/local/bin/jamf setOFP -mode none

jamf policy -event fwpsswd

#User stuff like upgrading permissions and remove from AD
getUser=`ls -l /dev/console | awk '{ print $3 }'`
dseditgroup -o edit -a $getUser -T group admin
dsconfigad -force -remove -u johnnynobody -p nopassword

#get rid of apps
jamf policy -event uninstallCP

/Library/Application\ Support/CrashPlan/Unistall.app/Contents/Resources/unistall.sh
sleep 2
rm -rf /Library/Application\ Support/CrashPlan
rm -rf /Applications/CrashPlan.app


#byebyeOpenDNS

launchctl remove com.opendns.osx.RoamingClientMenubar
launchctl remove com.opendns.osx.RoamingClientConfigUpdater
launchctl remove com.opendns.osx.RoamingClientConfigUpdater 
	
sleep 5

for i in '/Library/LaunchDaemons/com.opendns.osx.RoamingClientConfigUpdater.plist' '/Library/LaunchAgents/com.opendns.osx.RoamingClientMenubar.plist' '/Applications/OpenDNS Roaming Client' '/		Library/Application Support/OpenDNS Roaming Client' '/usr/local/sbin/dnscrypt-proxy' '/usr/local/share/man/man8/dnscrypt-proxy.8' '/var/lib/data/opendns' '/usr/local/lib/dnscrypt-proxy' 
    do rm -fr \"$i\"

done; 

killall RoamingClientMenubar
killall dnscrypt-proxy

rm -rf /Library/LaunchAgents/com.opendns.osx.RoamingClientMenubar.plist
rm -rf /Library/LaunchDaemons/com.opendns.osx.RoamingClientConfigUpdater.plist
rm -rf /Library/Application\ Support/OpenDNS\ Roaming\ Client
rm -rf /usr/local/lib/dnscrypt-proxy
rm -rf /Applications/OpenDNS\ Roaming\ Client/
	
pkgutil --forget com.opendns.osx.RoamingClient
	


#peace out dyknow

launchctl unload /Library/LaunchAgents/com.dyknow.monitor.plist
launchctl remove com.dyknow.monitor.plist
launchctl unload /Library/LaunchDaemons/com.dyknow.update.plist
launchctl remove com.dyknow.update.plist

ps ax |  grep "/Applications/.cloud/DyKnow.app/Contents/MacOS/DyKnow" | awk '{print $1}' | xargs kill -9 2> /dev/null
killall DyKnow

rm -rf /Library/.dyknow
rm -rf "/Library/Application Support/.dyknow"
rm -rf "/Library/Application Support/DyKnow"
rm -rf /Library/LaunchAgents/com.dyknow.monitor.plist
rm -rf /Library/LaunchDaemons/com.dyknow.update.plist

rm -rf /Applications/DyKnow.app
rm -rf /Applications/DyKnowLogSender.app

rm -rf /Applications/.cloud




rm -rf /Applications/CrashPlan.app
rm -rf /Applications/Inspiration\ 9
rm -rf /Applications/Kidspiration\ 3
rm -rf /Applications/SAM\ Animation.app
rm -rf /Applications/Securexam
rm -rf /Applications/ERB\ Secure\ Browser.app
rm -rf /Applications/Adobe*
rm -rf /Applications/Zotero.app

jamf policy -event removeOffice2011

ps ax |  grep "/Applications/Microsoft Word.app" | awk '{print $1}' | xargs kill -9 2> /dev/null
ps ax |  grep "/Applications/Microsoft Excel.app" | awk '{print $1}' | xargs kill -9 2> /dev/null
ps ax |  grep "/Applications/Microsoft PowerPoint.app" | awk '{print $1}' | xargs kill -9 2> /dev/null
ps ax |  grep "/Applications/Microsoft Outlook.app" | awk '{print $1}' | xargs kill -9 2> /dev/null

rm -rf /Library/Preferences/com.microsoft.office.licensingV2.plist
rm -rf $HOME/Library/Group\ Containers/UBF8T346G9.Office/com.microsoft.Office365.plist
rm -rf $HOME/Library/Group\ Containers/UBF8T346G9.Office/com.microsoft.e0E2OUQxNUY1LTAxOUQtNDQwNS04QkJELTAxQTI5M0JBOTk4O.plist
rm -rf $HOME/Library/Group\ Containers/UBF8T346G9.Office/e0E2OUQxNUY1LTAxOUQtNDQwNS04QkJELTAxQTI5M0JBOTk4O


/usr/bin/security delete-internet-password -s 'msoCredentialSchemeADAL' 2> /dev/null 1> /dev/null
/usr/bin/security delete-internet-password -s 'msoCredentialSchemeLiveId' 2> /dev/null 1> /dev/null


sleep 5

#bye Q, nice knowing you
#dscl . -delete /Users/q
#rm -rf /Users/q
sysadminctl -deleteUser q

sleep 3

killall "Self Service"

#the final step. Remove jamf
/usr/local/bin/jamf removeFramework
