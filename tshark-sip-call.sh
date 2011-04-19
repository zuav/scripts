#!/bin/sh
#
# $1 -- caller IP address
# $2 -- callee phone IP address
#
leftleg=$1
rightleg=$2

shift 2

tshark $* -n -i eth0 \( \( \( src host $leftleg  \) and \( dst host $rightleg \) \) or \
                        \( \( src host $rightleg \) and \( dst host $leftleg  \) \) \
                     \)
