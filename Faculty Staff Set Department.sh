#!/bin/sh

pashuapath="/usr/local/saes/Pashua.app/Contents/MacOS/Pashua"

pashua_run() {

    # Write config file
    local pashua_configfile=`/usr/bin/mktemp /tmp/pashua_XXXXXXXXX`
    echo "$1" > "$pashua_configfile"

    if [ "" = "$pashuapath" ]
    then
        >&2 echo "Error: Pashua could not be found"
        exit 1
    fi

    # Get result
    local result=$("$pashuapath" "$pashua_configfile")

    # Remove config file
    rm "$pashua_configfile"

    oldIFS="$IFS"
    IFS=$'\n'

    # Parse result
    for line in $result
    do
        local name=$(echo $line | sed 's/^\([^=]*\)=.*$/\1/')
        local value=$(echo $line | sed 's/^[^=]*=\(.*\)$/\1/')
        eval $name='$value'
    done

    IFS="$oldIFS"
}

#API login info
apiuser=***REMOVED***
apipass='***REMOVED***'
jamfProURL="https://***REMOVED***:8443"

#update via serial number
apiURL="JSSResource/computers/serialnumber"
MacSerial=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformSerialNumber/{print $4}')

#XML header stuff
xmlHeader="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"

#Current User stuff
getUser=$(ls -l /dev/console | awk '{ print $3 }')
#getUser=$3
getRealName=$(id -F "$getUser")

#API data load
xmlresult=$(curl -k "$jamfProURL/JSSResource/departments" --user "$apiuser:$apipass"  -H "Accept: application/xml" --silent | xmllint --format -  | awk -F'>|<' '/<name>/{print $3","}') 

#Cut last character
xmlresult=${xmlresult%?}


#Replace and cut the lines we don't need
tweaked=$(sed 's/,/ \\\npop.option =/g' <<< $xmlresult)
tweaked=$(echo $tweaked | grep -v "AppleTVs" | grep -v "iPads" | grep -v "Class" | grep -v "Cart" | grep -v "Video" | grep -v "Library" | grep -v "Macs")
#echo $tweaked

conf="#Set window title
*.title = Select Department
*.floating = 1
# Add a popup menu

pop.type = popup
pop.label = Please select your department
pop.width = 300
pop.option = $tweaked"
pashua_run "$conf"

#apiData="<computer><location><username>$getUser</username><real_name>$getRealName</real_name><department>$pop</department></location></computer>"

#curl -sSkiu ${apiuser}:${apipass} "${jamfProURL}/${apiURL}/${MacSerial}" \
#	-H "Content-Type: text/xml" \
#	-d "${xmlHeader}${apiData}" \
#	-X PUT > /dev/null

jamf recon -endUsername $getUser -department "$pop" -building "Postoak" -realname "$getRealName" -email "$getUser@saes.org"