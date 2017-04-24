#!/bin/bash

Adapter=en0

FoundGuest=`networksetup -listpreferredwirelessnetworks $Adapter | grep "SAES Guest Wifi"`

if [ "$FoundGuest" == '	SAES Guest Wifi' ]; then
	ConnectedtoGuest=`networksetup -getairportnetwork $Adapter | awk '{ print $4 }'`
	if [ "$ConnectedtoGuest" == 'SAES Guest Wifi' ]; then
			#Gotta disconnect first to remove it
			networksetup -setairportpower $Adapter off
			networksetup -removepreferredwirelessnetwork $Adapter "SAES Guest Wifi"
			networksetup -setairportpower $Adapter on
	else
			networksetup -removepreferredwirelessnetwork $Adapter "SAES Guest Wifi"
	fi
fi

	
