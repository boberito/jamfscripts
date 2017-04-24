#!/bin/sh

launchctl unload /Library/LaunchDaemons/com.crashplan.engine.plist
rm -rf /Library/Caches/CrashPlan/*
launchctl load /Library/LaunchDaemons/com.crashplan.engine.plist
