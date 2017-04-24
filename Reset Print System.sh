#!/bin/sh

launchctl stop org.cups.cupsd
mv /etc/cups/cupsd.conf /etc/cups/cupsd.conf.backup
cp /etc/cups/cupsd.conf.default /etc/cups/cupsd.conf
mv /etc/cups/printers.conf /etc/cups/printers.conf.backup
launchctl start org.cups.cupsd
