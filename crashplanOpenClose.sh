#!/bin/sh

osascript -e 'tell application "CrashPlan" to activatetell application "Finder" to set visible of process "CrashPlan" to falsedelay 12tell application "CrashPlan" to quit'

open "/Applications/CrashPlan.app/Contents/Resources/CrashPlan menu bar.app"