#!/bin/sh


osascript -e 'tell application "Microsoft Database Daemon" to quit'
osascript -e 'tell application "Microsoft AU Daemon" to quit'
osascript -e 'tell application "Office365Service" to quit'
rm -R '/Applications/Microsoft Communicator.app/'
rm -R '/Applications/Microsoft Lync.app/'
rm -R '/Applications/Microsoft Messenger.app/'
rm -R '/Applications/Microsoft Office 2011/'
rm -R '/Applications/Remote Desktop Connection.app/'
rm -R '/Library/Application Support/Microsoft/'
rm -R /Library/Automator/*Excel*
rm -R /Library/Automator/*Office*
rm -R /Library/Automator/*Outlook*
rm -R /Library/Automator/*PowerPoint*
rm -R /Library/Automator/*Word*
rm -R /Library/Automator/*Workbook*
rm -R '/Library/Automator/Get Parent Presentations of Slides.action'
rm -R '/Library/Automator/Set Document Settings.action'
rm -R /Library/Fonts/Microsoft/
mv '/Library/Fonts Disabled/Arial Bold Italic.ttf' /Library/Fonts
mv '/Library/Fonts Disabled/Arial Bold.ttf' /Library/Fonts
mv '/Library/Fonts Disabled/Arial Italic.ttf' /Library/Fonts
mv '/Library/Fonts Disabled/Arial.ttf' /Library/Fonts
mv '/Library/Fonts Disabled/Brush Script.ttf' /Library/Fonts
mv '/Library/Fonts Disabled/Times New Roman Bold Italic.ttf' /Library/Fonts
mv '/Library/Fonts Disabled/Times New Roman Bold.ttf' /Library/Fonts
mv '/Library/Fonts Disabled/Times New Roman Italic.ttf' /Library/Fonts
mv '/Library/Fonts Disabled/Times New Roman.ttf' /Library/Fonts
mv '/Library/Fonts Disabled/Verdana Bold Italic.ttf' /Library/Fonts
mv '/Library/Fonts Disabled/Verdana Bold.ttf' /Library/Fonts
mv '/Library/Fonts Disabled/Verdana Italic.ttf' /Library/Fonts
mv '/Library/Fonts Disabled/Verdana.ttf' /Library/Fonts
mv '/Library/Fonts Disabled/Wingdings 2.ttf' /Library/Fonts
mv '/Library/Fonts Disabled/Wingdings 3.ttf' /Library/Fonts
mv '/Library/Fonts Disabled/Wingdings.ttf' /Library/Fonts
rm -R /Library/Internet\ Plug-Ins/SharePoint*
rm -R /Library/LaunchDaemons/com.microsoft.office.licensing.helper.plist
rm -R /Library/Preferences/com.microsoft.office.licensing.plist
rm -R /Library/PrivilegedHelperTools/com.microsoft.office.licensing.helper
OFFICERECEIPTS=$(pkgutil --pkgs=com.microsoft.office.*)
for ARECEIPT in $OFFICERECEIPTS
	do
		pkgutil --forget $ARECEIPT
	done
	rm -R '/Library/Application Support/Microsoft/MAU2.0'

exit 0