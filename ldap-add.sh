#!/bin/sh
#
#
# $1 -- host, ldap://unisonproject.com or ldap://ldap.unison.org
# $2 -- file with entry description
#

DN="uid=root,cn=admins,cn=system"
password=LKdjoi32kasda
host=$1
file=$2

shift 2

ldapadd -x -D $DN -w $password -H $host -f $file $*
