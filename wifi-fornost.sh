#!/bin/sh
#/etc/init.d/avahi-daemon stop
#/etc/init.d/NetworkManager stop
/etc/init.d/wicd stop
/etc/init.d/avahi-daemon stop

ifconfig wlan0 down
ifconfig wlan0 up
iwconfig wlan0 essid fornost
iwconfig wlan0 key 31323334353637383930313233
sleep 3
dhclient wlan0
