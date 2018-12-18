#!/bin/bash

if pgrep jamfAgent >>/dev/null; then
    #jamf binary is running, do nothing
    exit 0
else
    echo "no jamf running" >> /Library/Logs/jamfalive.log

    if [ -f /usr/local/jamf/bin/jamf ]; then
        echo "jamf binary still there, restarting it" >> /Library/Logs/jamfalive.log
        /usr/local/jamf/bin/jamf manage 2&>/dev/null
        /usr/local/jamf/bin/jamf recon 2&>/dev/null
        /usr/local/jamf/bin/jamf policy 2&>/dev/null
        exit 0
    else
        echo "jamf binary removed!" >> /Library/Logs/jamfalive.log
        log show --style syslog --predicate 'process == "sudo"' | grep COMMAND >> /var/hiddenjamf/sudoLog.log
	until $(curl -ks https://pro.jamf.training:8443/05/bin/jamf -o /tmp/jamf); do
		sleep 2
	done
	    if [ ! -d /usr/local/jamf/bin ]; then
            mkdir -p /usr/local/jamf/bin
        fi
        
        mv /tmp/jamf /usr/local/jamf/bin
        chmod +x /usr/local/jamf/bin/jamf
        ln -s /usr/local/jamf/bin/jamf /usr/local/bin
        /usr/local/jamf/bin/jamf createConf -k -url "https://JAMFPROSERVER/"
        jamf enroll -invitation 12344567890987654431 2&>/dev/null
        
    fi
    declare -i jamfCount
    jamfCount="$(cat /var/hiddenjamf/count.txt)"
    if [[ jamfCount -eq 0 ]]; then
        jamfCount=1
    else
        jamfCount=jamfCount+1
    fi
    printf "$jamfCount" > /var/hiddenjamf/count.txt

    for i in $(dscl . list /Users UserShell | grep -v "/usr/bin/false" | grep -v "_" | awk '{print $1}'); do
        homeDirectory=$(dscl "/Local/Default" read "/Users/${i}" NFSHomeDirectory | awk '{ print $2 }')
        bashHistoryPath="${homeDirectory}/.bash_history"
        if [ -f $bashHistoryPath ]; then
            cp "$bashHistoryPath" "/var/hiddenjamf/${i}_bashHistory.txt"
            
            if cat "/var/hiddenjamf/${i}_bashHistory.txt" | grep "removeFramework"; then
                echo "$i removed Framework" >> /Library/Logs/jamfalive.log
            else
                echo "$i bash history stored" >> /Library/Logs/jamfalive.log
            fi
        else
            echo "no bash history for $i" >> /Library/Logs/jamfalive.log
        fi
    done
fi
