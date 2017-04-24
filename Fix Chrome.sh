#!/bin/sh

getUser=`ls -l /dev/console | awk '{ print $3 }'`
UserHome="/Users/$getUser"

ps ax | grep "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" | awk '{print $1}' | xargs kill -9 2> /dev/null
mv "$UserHome/Library/Application Support/Google/Chrome/Default/Bookmarks" $UserHome/Bookmarks
rm -rf "$UserHome/Library/Application Support/Google/Chrome"
mkdir -p "$UserHome/Library/Application Support/Google/Chrome/Default"
mv $UserHome/Bookmarks "$UserHome/Library/Application Support/Google/Chrome/Default/Bookmarks"
chmod -R 700 "$UserHome/Library/Application Support/Google/Chrome/"
chown -R $getUser "$UserHome/Library/Application Support/Google/Chrome/"