#!/bin/bash

Adapter=en0

FoundGuest=`networksetup -listpreferredwirelessnetworks $Adapter | grep "S.A.E.S." | grep -v "S.A.E.S. Students"`

if [ "$FoundGuest" == '	S.A.E.S.' ]; then
	ConnectedtoGuest=`networksetup -getairportnetwork $Adapter | awk '{  print $4 " "$5  }'`
	if [ "$ConnectedtoGuest" == 'S.A.E.S. ' ]; then
			#Gotta disconnect first to remove it
			networksetup -setairportpower $Adapter off
			networksetup -removepreferredwirelessnetwork $Adapter "S.A.E.S."
			sleep 1
			networksetup -setairportpower $Adapter on
	else
			networksetup -removepreferredwirelessnetwork $Adapter "S.A.E.S."
	fi
fi

	
