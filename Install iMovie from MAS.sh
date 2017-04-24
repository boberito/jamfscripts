#!/bin/sh


id='appleID login'
passwd='apple ID password'

#sign out
/var/mas/mas signout

sleep 3

#sign in
/var/mas/mas signin $id $passwd

sleep 3

#install apps
if [ -d "/Applications/iMovie.app" ]; then
    if [ $4 == "Yes" ]; then
        /var/mas/mas install 408981434
    else
        echo "iMovie Already Installed"
    fi
else
    /var/mas/mas install 408981434
fi

#sign out

/var/mas/mas signout

exit 0