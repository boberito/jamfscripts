#!/bin/sh

StartupDisk=`systemsetup -liststartupdisks`
systemsetup -setstartupdisk $StartupDisk