#!/bin/sh

#installs and sets up CP on machines that don't have it installed
#downloads crashplan
#Crashplan download link is found in the crashplan server App Downloads ---> Download App link
#input URL into policy option 4
#writes configuration file deployment property based off of student or technology or faculty/staff
#installs CP

CurrentUser=$3
CrashPlanURL=$4

curl -k -s "$CrashPlanURL" > /var/tmp/CP.dmg

mkdir "/Library/Application Support/CrashPlan/"
chmod -R 775 "/Library/Application Support/CrashPlan/"

if id "$CurrentUser" | grep "Students"; then
	#Student Key
		cat <<EOF>"/Library/Application Support/CrashPlan/deploy.properties"
DEPLOYMENT_URL=CRASHPLAN URL
DEPLOYMENT_POLICY_TOKEN=ENTER TOKEN
CP_SILENT=false
SSL_WHITELIST=ENTER SSL WHITELIST
EOF
elif id "$CurrentUser" | grep "Tech"; then
	#Technology Key
		cat <<EOF>"/Library/Application Support/CrashPlan/deploy.properties"
DEPLOYMENT_URL=CRASHPLAN URL
DEPLOYMENT_POLICY_TOKEN=ENTER TOKEN
CP_SILENT=false
SSL_WHITELIST=ENTER SSL WHITELIST
EOF
else	
	#Faculty & Staff Key
		cat <<EOF>"/Library/Application Support/CrashPlan/deploy.properties"
DEPLOYMENT_URL=CRASHPLAN URL
DEPLOYMENT_POLICY_TOKEN=ENTER TOKEN
CP_SILENT=false
SSL_WHITELIST=ENTER SSL WHITELIST
EOF
fi

chmod 777 "/Library/Application Support/CrashPlan/deploy.properties"

hdiutil attach "/var/tmp/CP.dmg" -noverify -nobrowse -quiet
installer -package "/Volumes/Code42CrashPlan/Install Code42 CrashPlan.pkg" -target LocalSystem
hdiutil detach /Volumes/Code42CrashPlan

rm -rf /var/tmp/CP.dmg
