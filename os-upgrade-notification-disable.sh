#!/bin/bash

# Disable macOS Upgrade notifications

# Step 1: prevent the update which brings the notification down
softwareupdate --ignore macOSInstallerNotification_GM

/usr/bin/defaults write /Library/Preferences/com.apple.noticeboard.plist LastNoticeboardCatalogCheck "$(date -u "+%F %T %z")"
/usr/bin/defaults write /Library/Preferences/com.apple.noticeboard.plist "com.apple.noticeboard.notification.mojave.2.0" -dict dismissalCount 4 lastDismissedDate "$(date -u "+%F %T %z")"
/usr/bin/defaults write /Library/Preferences/com.apple.noticeboard.plist identifiers -array "com.apple.noticeboard.notification.mojave.2.0"

# Step 2: delete the file if it's already on the computer
if [[ -d /Library/Bundles/OSXNotification.bundle ]]; then
    
    rm -rf /Library/Bundles/OSXNotification.bundle
else
    echo "OSXNotification.bundle not found."
fi
