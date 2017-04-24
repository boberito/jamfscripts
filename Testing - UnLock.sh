#!/bin/sh

mv /System/Library/Services/AppleSpell.service/Contents/Resources.disabled /System/Library/Services/AppleSpell.service/Contents/Resources
profiles -R -F "/var/tmp/Testing - Lockdown.mobileconfig"