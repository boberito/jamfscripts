#!/bin/sh


/usr/sbin/diskutil mount Recovery\ HD
/usr/bin/hdiutil attach -quiet /Volumes/Recovery\ HD/com.apple.recovery.boot/BaseSystem.dmg
if [ -f /Volumes/Mac\ OS\ X\ Base\ System/Applications/Utilities/Firmware\ Password\ Utility.app/Contents/Resources/setregproptool ]; then
        cp /Volumes/Mac\ OS\ X\ Base\ System/Applications/Utilities/Firmware\ Password\ Utility.app/Contents/Resources/setregproptool /Library/Application\ Support/JAMF/bin/
        /usr/bin/hdiutil detach /Volumes/Mac\ OS\ X\ Base\ System
else
        cp /Volumes/OS\ X\ Base\ System/Applications/Utilities/Firmware\ Password\ Utility.app/Contents/Resources/setregproptool /Library/Application\ Support/JAMF/bin/
        /usr/bin/hdiutil detach /Volumes/OS\ X\ Base\ System
fi

/usr/sbin/diskutil unmount Recovery\ HD
