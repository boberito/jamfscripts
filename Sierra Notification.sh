#!/bin/bash

SierraOrNot=`system_profiler SPSoftwareDataType | grep macOS | cut -d : -f 2 | cut -c 8-12`

if [ "$SierraOrNot" = "10.12" ]; then
	 jamf -recon
else
	/var/tmp/CocoaDialog.app/Contents/MacOS/CocoaDialog bubble --no-timeout --title "Upgrade to macOS Sierra" --text "Please upgrade to macOS Sierra found in Self Service.Thank you, Tech" --x-placement center --y-placement center --icon "info"
	open "/Applications/SAES Self Service.app"
fi

