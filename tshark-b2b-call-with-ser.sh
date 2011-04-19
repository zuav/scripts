#!/bin/sh
#
# $1 -- host where b2bua is started
# $2 -- host where ser is started
# $3 -- left leg IP address
# $4 -- right leg IP address
#
b2bhost=$1
serhost=$2
leftleg=$3
rightleg=$4

shift 4

tshark $* -n -i eth0 -R "
(((ip.src == $leftleg)  and (ip.dst == $serhost)) or \
 ((ip.dst == $leftleg ) and (ip.src == $serhost)) or \
 ((ip.src == $rightleg) and (ip.dst == $serhost)) or \
 ((ip.dst == $rightleg) and (ip.src == $serhost)) or \
 ((ip.src == $serhost ) and (ip.dst == $serhost)) or \
 ((ip.src == $b2bhost ) and (ip.dst == $serhost)) or \
 ((ip.dst == $b2bhost ) and (ip.dst == $serhost)))   \
and sip and (not arp) and (not icmp)"
