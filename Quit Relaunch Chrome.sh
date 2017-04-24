#!/bin/sh


ps ax |  grep "/Applications/Google Chrome.app" | awk '{print $1}' | xargs kill -9 2> /dev/null
rm -rf "/Users/$3/Library/Application Support/Google/Chrome"
sleep 3
open "/Applications/Google Chrome.app"