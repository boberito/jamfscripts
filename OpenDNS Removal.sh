#byebyeOpenDNS

	launchctl remove com.opendns.osx.RoamingClientMenubar
	launchctl remove com.opendns.osx.RoamingClientConfigUpdater
	launchctl remove com.opendns.osx.RoamingClientConfigUpdater

	sleep 5

	for i in '/Library/LaunchDaemons/com.opendns.osx.RoamingClientConfigUpdater.plist' '/Library/LaunchAgents/com.opendns.osx.RoamingClientMenubar.plist' '/Applications/OpenDNS Roaming Client' '/		Library/Application Support/OpenDNS Roaming Client' '/usr/local/sbin/dnscrypt-proxy' '/usr/local/share/man/man8/dnscrypt-proxy.8' '/var/lib/data/opendns' '/usr/local/lib/dnscrypt-proxy'
	do rm -fr \"$i\"

	done;

	killall RoamingClientMenubar
	killall dnscrypt-proxy

	rm -rf /Library/LaunchAgents/com.opendns.osx.RoamingClientMenubar.plist
	rm -rf /Library/LaunchDaemons/com.opendns.osx.RoamingClientConfigUpdater.plist
	rm -rf /Library/Application\ Support/OpenDNS\ Roaming\ Client
	rm -rf /usr/local/lib/dnscrypt-proxy
	rm -rf /Applications/OpenDNS\ Roaming\ Client/

	pkgutil --forget com.opendns.osx.RoamingClient
