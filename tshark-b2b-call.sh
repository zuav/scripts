#!/bin/sh
#
# $1 -- host where b2bua is started
# $2 -- left leg IP address
# $3 -- right leg IP address
#
b2bhost=$1
leftleg=$2
rightleg=$3

shift 3

tshark $* -n -i eth0 \( \( src host $leftleg  and dst host $b2bhost \) or \
                        \( dst host $leftleg  and src host $b2bhost \) or \
                        \( src host $rightleg and dst host $b2bhost \) or \
                        \( dst host $rightleg and src host $b2bhost \) \) \
                     and \
                     \( not arp \) \
                     and \
                     \( not icmp \)
