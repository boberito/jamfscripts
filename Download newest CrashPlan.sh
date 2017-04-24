#!/bin/sh

curl http://saes-cp-a.saes.org:4280/download/CrashPlanPROe_Mac.dmg > /var/tmp/CP.dmg
hdiutil attach /var/tmp/CP.dmg
installer -pkg /Volumes/CrashPlanPROe/Install\ CrashPlanPROe.pkg -target /
hdiutil detach /Volumes/CrashPlanPROe/
rm -rf /var/tmp/CP.dmg
