#!/bin/sh


getUser=`ls -l /dev/console | awk '{ print $3 }'`

dseditgroup -o edit -a $getUser -T group admin
