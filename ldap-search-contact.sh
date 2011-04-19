#!/bin/sh
#
#
# $1 -- host, ldap://unisonproject.com or ldap://ldap.unison.org
# $2 -- uid, f.e. azhukov
#

DN="uid=root,cn=admins,cn=system"
password="67240d19bf"
#DN="uid=zuav,ou=Main,o=Middle-earth"
#password=qwerty12
#DN="uid=admin,cn=admins,cn=system"
#password=testadmin
#DN="uid=root,cn=admins,cn=system"
#password=5b2477093b
scope="base"
host=$1
uid=$2

shift 2

#ldapsearch -b "uid=$uid,ou=Main,o=Middle-earth" -D $DN -w $password -H $host  -s $scope  "objectClass=UMSAccount" $*
ldapsearch -x -D $DN -w $password -H $host -b "uid=$uid,uid=MainBook,o=Middle-earth"  -s $scope  "objectClass=UMSContact" $*
#ldapsearch -x -D $DN -w $password -H $host -b "uid=$uid,ou=Main,o=Middle-earth"  -s $scope  "objectClass=UMSAccount" $*
#ldapsearch -x -D $DN -w $password -H $host -b "uid=$uid,ou=_system,o=Middle-earth"  -s $scope  "(objectClass=UMSOriginationProvider)" $*
#ldapsearch -x -D $DN -w $password -H $host -s $scope  "(objectClass=UMSHuntGroupManagers)" $*
