#!/bin/sh
# CrashPlan Uninstall script.

_cleanAppSupport() {
    local appSupportFolder="$1"
    local installedAsUser="$2"
    for file in `ls -A "$appSupportFolder"`; do
        deleteFile=true
        # retain .identity
        if [ ".identity" == "$file" ]; then
            deleteFile=false
            # strip out the keys
            identityFile="$appSupportFolder"/.identity
            if [ "$installedAsUser" = "true" ]; then
                sed -e '/dataKey/ d' -e '/secureDataKey/ d' -e '/privateKey/ d' -e '/publicKey/ d' -e '/securityKeyType/ d' -e '/offlinePasswordHash/ d' "$identityFile" > "${identityFile}.tmp"
                mv "${identityFile}.tmp" "$identityFile"
                chmod 600 "$identityFile"
            else
                sudo sed -e '/dataKey/ d' -e '/secureDataKey/ d' -e '/privateKey/ d' -e '/publicKey/ d' -e '/securityKeyType/ d' -e '/offlinePasswordHash/ d' "$identityFile" > "${identityFile}.tmp"
                sudo mv "${identityFile}.tmp" "$identityFile"
                sudo chmod 600 "$identityFile"
            fi
            # If the user is an installed as root but running as user, we'll still need sudo to do stuff.
            if [ "$runAsRoot" != "true" ] && [ "$installedAsUser" != "true" ]; then
                installingGroup=`id -gn $installingUser`
                sudo chown $installingUser:$installingGroup "$identityFile"
            fi
        fi

        # Retain non-empty backupArchives or PROServer folders.        
        if [ "PROServer" == "$file" ] || [ "backupArchives" == "$file" ]; then
            # If folder has data, do not delete it
            if [ 0 -lt `ls -lA "$appSupportFolder/$file" | wc -l` ]; then
                deleteFile=false
            fi
        fi
        
        if [ "true" = "$deleteFile" ]; then
            if [ "$installedAsUser" = "true" ]; then
                rm -Rfv "$appSupportFolder/$file"
            else
                sudo rm -Rfv "$appSupportFolder/$file"
            fi
        fi
    done
}


# These are default values that will be overridden if the installVarsFile is sourced.
# So do not rename these unless you get all the other scripts that depend on them.
runAsRoot=true
enginePlist="/Library/LaunchDaemons/com.crashplan.engine.plist"
installingUser=`id -un`

# Check the user install first, we'll call it a user install if either they've got an
# installVarsFile or they're calling it from inside their own App support directory.
appSupportDir="/Library/Application Support/CrashPlan"
installVarsFile="${appSupportDir}/install.vars"
if [ -f "$HOME/$installVarsFile" ] && [ -d "$HOME/$appSupportDir" ]; then
    source "$HOME/$installVarsFile"
    installedAsUser=true
    export logFile="$HOME/Library/Logs/crashplan_uninstall.log"
    echo "`date` : User install detected, uninstalling as user."                                             >> $logFile 2>&1
elif [ -f "$installVarsFile" ] && [ -d "$appSupportDir" ]; then
    source "$installVarsFile"
    export logFile="/Library/Logs/crashplan_uninstall.log"
    echo "`date` : Root install detected, uninstalling as administrator."                                    >> $logFile 2>&1
fi

echo "`date` : NOTICE: This will remove CrashPlan software and configuration information."                   >> $logFile 2>&1
echo "`date` : NOTICE: Automatic backup will cease."                                                         >> $logFile 2>&1
echo "`date` : NOTICE: Backup archives from other computers will NOT be deleted."                            >> $logFile 2>&1

#
# When the engine is running as the user, it maybe running in either the global launchd or in the 
# installing users launchd process.  We need to check for both.
#

if [ -f "$HOME/$appSupportDir/unloadEngine.sh" ]; then
	source "$HOME/$appSupportDir/unloadEngine.sh"
else
	source "$appSupportDir/unloadEngine.sh"
fi



if [ "$installedAsUser" = "true" ]; then

    # kill the menu bar
    echo "`date` : Killing the menu bar app."                                                                >> $logFile 2>&1
    killall -9 "${menuBarAppName}"                                                                           >> $logFile 2>&1


    if [ -e "${HOME}/Library/LaunchAgents/com.crashplan.engine.plist" ]; then
        # This handles the case where the user is not admin and can't do sudo
        echo "`date` : Removing the launcher from my Library/LaunchAgents folder..."                         >> $logFile 2>&1
        rm -fv "${HOME}/Library/LaunchAgents/com.crashplan.engine.plist"                                     >> $logFile 2>&1
        rm -fv "${HOME}/Library/LaunchAgents/com.crashplan.cleanup.plist"                                    >> $logFile 2>&1
    fi

    echo "`date` :  Removing the application files..."                                                       >> $logFile 2>&1

    chflags noschg $HOME/Applications/CrashPlan.app                                                          >> $logFile 2>&1

    # Delete the whole CrashPlan.app directory.
    rm -Rfv $HOME/Applications/CrashPlan.app                                                                 >> $logFile 2>&1

    # These folders need to be deleted regardless
    echo "`date` : Removing the supporting files and directories..."                                         >> $logFile 2>&1

    # 
    # Clean up the /Library/Application Support/CrashPlan folder.
    # But leave non-empty backupArchives or PROServer folders.
    #
    _cleanAppSupport "$HOME/Library/Application Support/CrashPlan" true                                      >> $logFile 2>&1

    rm -Rfv $HOME/Library/Logs/CrashPlan                                                                     >> $logFile 2>&1
    rm -Rfv $HOME/Library/Caches/CrashPlan                                                                   >> $logFile 2>&1
    rm -Rfv $HOME/Library/Receipts/*CrashPlan*                                                               >> $logFile 2>&1
    pkgutil --forget com.crashplan                                                                           >> $logFile 2>&1

else
    # kill the menu bar
    echo "`date` : Killing the menu bar app."                                                                >> $logFile 2>&1
    killall -9 "${menuBarAppName}"

    echo
    if [ -e "${HOME}/Library/LaunchAgents/com.crashplan.engine.plist" ]; then
        # This handles the case where the user is not admin and can't do sudo
        echo "`date` : Removing the launcher from my Library/LaunchAgents folder..."                         >> $logFile 2>&1
        rm -fv "${HOME}/Library/LaunchAgents/com.crashplan.engine.plist"
        rm -fv "${HOME}/Library/LaunchAgents/com.crashplan.cleanup.plist"
    fi
    if [ -e "$enginePlist" ]; then
        echo "`date` : Removing the backup engine launcher ..."                                              >> $logFile 2>&1
        sudo rm -fv "$enginePlist"
    fi
    if [ -e "/Library/LaunchDaemons/com.crashplan.engine.plist" ]; then
        echo "`date` : Removing an old Launcher from the /Library/LaunchDaemons folder..."                   >> $logFile 2>&1
        sudo rm -fv /Library/LaunchDaemons/com.crashplan.engine.plist
    fi

    echo "`date` : Removing the application files..."                                                        >> $logFile 2>&1

    sudo chflags noschg /Applications/CrashPlan.app

    # Delete the whole CrashPlan.app directory.
    sudo rm -Rfv /Applications/CrashPlan.app                                                                 >> $logFile 2>&1

    # These folders need to be deleted regardless
    echo "`date` : Removing the supporting files and directories..."                                         >> $logFile 2>&1

    # 
    # Clean up the /Library/Application Support/CrashPlan folder.
    # But leave non-empty backupArchives or PROServer folders.
    #
    _cleanAppSupport "/Library/Application Support/CrashPlan"                                                >> $logFile 2>&1

    sudo rm -Rfv /Library/Logs/CrashPlan
    sudo rm -Rfv /Library/Caches/CrashPlan
    sudo rm -Rfv /Library/Receipts/*CrashPlan*
    sudo rm -Rfv /Library/Receipts/*RunAsUser.pkg
    sudo pkgutil --forget com.crashplan

    # These were left around by old installers
    sudo rm -fv  /var/log/cp-*.log

    # Remove stuff some old installers left in the /Resources directory
    if [ -e /Resources ]; then
        sudo rm -fv /Resources/post*
        sudo rm -fv /Resources/pre*
        sudo rm -fv /Resources/CrashPlan*
        # If /Resources is empty then delete it.
        if [ 0 = `ls -A /Resources | wc -l` ]; then
            sudo rm -Rfv /Resources
        fi
    fi

    if [ -f "$installVarsFile" ]; then
        # Doing this can cause the user based .identity file to incorrectly change permissions to root.
        echo "`date` : Looking for CrashPlan files and folders in users home folders..."                     >> $logFile 2>&1
        for u in `ls /Users`; do
            if [ -e "/Users/${u}/Library/Preferences/" ]; then
                sudo rm -fv /Users/"${u}"/Library/Preferences/*backup42*plist                                >> $logFile 2>&1
                sudo rm -fv /Users/"${u}"/Library/Preferences/*crashplan*plist                               >> $logFile 2>&1
            fi
            folder="/Users/${u}/Library/Application Support/CrashPlan"
            if [ -e "$folder" ]; then
                echo "`date` : Cleaning out $folder"                                                         >> $logFile 2>&1
                _cleanAppSupport "$folder"                                                                   >> $logFile 2>&1
            fi
        done
    else
        echo "`date` : Missing install.vars, skipping users."                                                >> $logFile 2>&1
    fi

fi
echo "`date` : NOTICE: CrashPlan has been uninstalled."                                                      >> $logFile 2>&1
echo "`date` : NOTICE: Backup archives from other computers have not been deleted."                          >> $logFile 2>&1

rm -rf "/Library/Application Support/CrashPlan"