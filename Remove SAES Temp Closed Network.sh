#!/bin/sh

networksetup -removepreferredwirelessnetwork en0 SAES-Temp-Closed
networksetup -setairportpower en0 off
sleep 1
networksetup -setairportpower en0 on