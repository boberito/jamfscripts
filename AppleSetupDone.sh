#!/bin/sh

if [ -f "/var/db/.AppleSetupDone"]; then
    exit 0
else
    touch /var/db/.AppleSetupDone
fi
