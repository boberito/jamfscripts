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
/var/mas/mas install 715768417

#sign out

/var/mas/mas signout

exit 0