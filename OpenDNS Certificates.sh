#!/bin/sh
/usr/bin/security add-trusted-cert -d -r trustRoot -p ssl -p basic -k /Library/Keychains/System.keychain /var/tmp/Certificates/OpenDNS-Root.crt
/usr/bin/security add-trusted-cert -d -r trustRoot -p ssl -p basic -k /Library/Keychains/System.keychain /var/tmp/Certificates/Cisco_Umbrella_Root_CA.cer
rm -rf /var/tmp/Certificates