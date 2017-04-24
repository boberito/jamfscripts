#!/bin/sh

getUser=`ls -l /dev/console | awk '{ print $3 }'`


rm -rf /Users/$getUser/Library/Application\ Support/Microsoft/Office
rm -rf /Users/$getUser/Documents/Microsoft\ User\ Data
rm -rf /Users/$getUser/Library/Preferences/com.microsoft.office.plist
rm -rf /Users/$getUser/Library/Preferences/com.microsoft.autoupdate2.plist
rm -rf /Users/$getUser/Library/Preferences/com.microsoft.error_reporting.plist
rm -rf /Users/$getUser/Library/Preferences/com.microsoft.Word.plist
