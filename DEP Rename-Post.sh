#!/bin/sh

#Runs at login to set computer name, re-joins AD, and sets user and department

InventoryTag=$(hostname)
LoggedInUser=$(ls -l /dev/console | awk '{ print $3 }')

echo "Hello $LoggedInUser on $InventoryTag"

#Checks if a faculty or staff...if not it's a student.
if dscl '/Active Directory/ACADEMIC/All Domains' -read /Users/"$LoggedInUser" | grep "Faculty and Staff"; then
    ComputerName=$InventoryTag$(echo $LoggedInUser | cut -c 2-)
    echo "Employee"
    #pops up pashua to set user and department
    jamf policy -event setdeptDEP
    
    touch /var/.faculty
    
    if [ -e "/var/.student" ]; then
	    rm /var/.student
	    echo "no longer student"
    fi
else
    echo "Student"
    ComputerName="S"$InventoryTag 
    #gets user info from AD to populate
    getclass=`dscl '/Active Directory/ACADEMIC/All Domains' -read /Users/$LoggedInUser dsAttrTypeNative:distinguishedName | awk '{ FS=","; print $2 }' | awk '{ FS="="; print $2 }' | tail -1`
    getRealName=$(id -F "$LoggedInUser")
    #getRealName=`dscl '/Active Directory/ACADEMIC/All Domains' -read /Users/$LoggedInUser RealName | grep -v ":"`
    
    if [ -e "/var/.staff" ]; then
	    rm /var/.staff
	    echo "no longer staff"
    fi
    if [ -e "/var/.faculty" ]; then
	    rm /var/.faculty
	    echo "no longer faculty"
    fi

    touch /var/.student
    echo "My Class is - $getclass"
    echo "My Full Name is - $getRealName"
    jamf recon -endUsername $LoggedInUser -department "$getclass" -building "Postoak" -realname "$getRealName" -email "$LoggedInUser@saes.org" &
fi

echo "My Computer's new name is $ComputerName"
echo $ComputerName > /var/.computername

#removes from AD, renames computer, and rejoins AD
#does an authenticated AD remove which removes it from AD server itself
dsconfigad -remove -u administrator -p ***REMOVED***
scutil --set ComputerName "$ComputerName"
scutil --set LocalHostName "$ComputerName"
scutil --set HostName "$ComputerName"
jamf setComputerName -name "$ComputerName"
dscacheutil -flushcache
jamf policy -event joinad

rm -f /var/tmp/computernames.csv

exit 0