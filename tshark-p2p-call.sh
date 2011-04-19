#!/bin/sh
#
# $1 -- host where SIP prixy is started
# $2 -- left phone IP address
# $3 -- right phone IP address
#
proxyhost=$1
leftleg=$2
rightleg=$3

shift 3

tshark $* -n -i eth0 \( \( src host $leftleg   \) or \
                        \( dst host $leftleg   \) or \
                        \( src host $proxyhost \) or \
                        \( dst host $proxyhost \) or \
                        \( src host $rightleg  \) or \
                        \( dst host $rightleg  \) \) \
                     and \
                     \( not arp \) \
                     and \
                     \( not icmp \)
