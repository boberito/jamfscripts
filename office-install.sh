#!/bin/sh

CurrentOfficeRelease=$(curl -s https://macadmins.software | grep "Office Suite Install" | awk -F "a href" '{ print $1 }' | awk -F ">" '{print $10}' | awk -F " " '{print $1}')
CurrentOfficeInstalled=$(defaults read /Applications/Microsoft\ Word.app/Contents/Info.plist CFBundleVersion)

if [ "$CurrentOfficeRelease" = "$CurrentOfficeInstalled" ]; then
    /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Microsoft Office 2016" -description "You currently have the most recent version of Microsoft Office installed" -button1 "Ok" -defaultButton 1
    exit 0
else
    mkdir /tmp/downloads
    cd /tmp/downloads

    OfficeURL=$(curl -s https://macadmins.software | grep "Office Suite Install" | awk -F "a href" '{ print $2 }' | awk -F "'" '{ print $2 }')
    curl -s -o office.pkg $OfficeURL
    installer -target / -pkg "/tmp/downloads/office.pkg"
    rm office.pkg
    rm -rf /tmp/downloads
    exit 0
fi
