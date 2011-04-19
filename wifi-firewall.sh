#!/bin/sh
/etc/init.d/avahi-daemon stop
/etc/init.d/NetworkManager stop
ifconfig wlan0 down
ifconfig wlan0 up
iwconfig wlan0 essid firewall
iwconfig wlan0 key 1947196999
sleep 3
dhclient wlan0
