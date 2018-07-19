#!/bin/sh

#installs and sets up CP on machines that don't have it installed
#downloads crashplan
#Crashplan download link is found in the crashplan server App Downloads ---> Download App link
#input URL into policy option 4
#writes configuration file deployment property based off of student or technology or faculty/staff
#installs CP



CurrentUser=$3
CrashPlanURL=$4
echo $3
echo $4

curl -k -s "$CrashPlanURL" > /var/tmp/CP.dmg

mkdir "/Library/Application Support/CrashPlan/"
chmod -R 775 "/Library/Application Support/CrashPlan/"

if id "$CurrentUser" | grep "Students"; then
	#Student Key
		cat <<EOF>"/Library/Application Support/CrashPlan/deploy.properties"
DEPLOYMENT_URL=https://saes-cp-a.saes.org:4285
DEPLOYMENT_POLICY_TOKEN=9116980d-4106-4d54-abb3-72000471eed6
CP_SILENT=false
SSL_WHITELIST=5783bcc4432f757676eca52e8dff7f86f40020c8
EOF
elif id "$CurrentUser" | grep "Tech"; then
	#Technology Key
		cat <<EOF>"/Library/Application Support/CrashPlan/deploy.properties"
DEPLOYMENT_URL=https://saes-cp-a.saes.org:4285
DEPLOYMENT_POLICY_TOKEN=fc23aa7c-7c87-4ba0-b163-7f3c50967c20
CP_SILENT=false
SSL_WHITELIST=5783bcc4432f757676eca52e8dff7f86f40020c8
EOF
else	
	#Faculty & Staff Key
		cat <<EOF>"/Library/Application Support/CrashPlan/deploy.properties"
DEPLOYMENT_URL=https://saes-cp-a.saes.org:4285
DEPLOYMENT_POLICY_TOKEN=e77873b7-39df-48f0-980f-a90591d5a080
CP_SILENT=false
SSL_WHITELIST=5783bcc4432f757676eca52e8dff7f86f40020c8
EOF
fi

chmod 777 "/Library/Application Support/CrashPlan/deploy.properties"

hdiutil attach "/var/tmp/CP.dmg" -noverify -nobrowse -quiet
installer -package "/Volumes/Code42CrashPlan/Install Code42 CrashPlan.pkg" -target LocalSystem
hdiutil detach /Volumes/Code42CrashPlan

rm -rf /var/tmp/CP.dmg
