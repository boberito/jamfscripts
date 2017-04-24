#!/bin/sh

if [ ! -d /Library/Application\ Support/Macromedia ]; then
	mkdir /Library/Application\ Support/Macromedia
	chown root:admin /Library/Application\ Support/Macromedia
	chmod 755 /Library/Application\ Support/Macromedia
fi

cat <<EOT > /Library/Application\ Support/Macromedia/mms.cfg
AutoUpdateDisable=1
SilentAutoUpdateEnable=0
EOT

