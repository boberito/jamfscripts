#!/bin/sh
#reads name
LOGPATH="/var/log/jamf.log"
NAME=`grep "Set Computer Name to" $LOGPATH | tail -1 | sed -e 's/.*Name\ to\ //'`

#Sets computer name
/usr/local/bin/jamf setComputerName -target / -name "$NAME"

