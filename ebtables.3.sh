#!/bin/sh



ebtables -P FORWARD DROP
ebtables -A FORWARD -p IPv4 --ip-src 172.16.1.4 -j DROP
ebtables -A FORWARD -p IPv4 --ip-src 172.16.1.4 -s ! 00:11:22:33:44:55 -j DROP
ebtables -A FORWARD -p IPv4   -j ACCEPT
ebtables -A FORWARD -p ARP    -j ACCEPT
ebtables -A FORWARD -p LENGTH -j ACCEPT

ebtables -P INPUT DROP
ebtables -A INPUT -p IPv4   -j ACCEPT
ebtables -A INPUT -p ARP    -j ACCEPT
ebtables -A INPUT -p LENGTH -j ACCEPT

ebtables -P OUTPUT DROP
ebtables -A OUTPUT -p IPv4   -j ACCEPT
ebtables -A OUTPUT -p ARP    -j ACCEPT
ebtables -A OUTPUT -p LENGTH -j ACCEPT
