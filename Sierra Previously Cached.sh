#!/bin/sh

if [ -a "/Library/Application Support/JAMF/Waiting Room/Install macOS Sierra.InstallESD.dmg" ]; then
    rm -rf "/Library/Application Support/JAMF/Waiting Room/Install macOS Sierra.InstallESD.dmg"
    rm -rf "/Library/Application Support/JAMF/Waiting Room/Install macOS Sierra.InstallESD.dmg.cache.xml"
    /usr/local/jamf/bin/jamf recon
fi
