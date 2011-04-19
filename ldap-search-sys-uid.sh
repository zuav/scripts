#!/bin/sh
#
#
# $1 -- host, ldap://unisonproject.com or ldap://ldap.unison.org
# $2 -- uid, f.e. azhukov
#
DN="uid=b2bua,ou=_system,o=Middle-earth"
password=01290806
scope="base"
host=$1
uid=$2

shift 2

#ldapsearch -x -D $DN -w $password -H $host -b "uid=$uid,uid=server,uid=config,o=system"  -s $scope  "objectClass=UMSSysAccount" $*
ldapsearch -x -D $DN -w $password -H $host  -s $scope  "(&(objectClass=UMSOriginationProvider)(umsactive=TRUE))" $*


