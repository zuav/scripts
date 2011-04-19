#!/bin/sh
#
#
# $1 -- host, ldap://unisonproject.com or ldap://ldap.unison.org
# $2 -- uid, f.e. azhukov
#

DN="uid=b2bua,ou=_system,o=Middle-earth"
password=63631306
#DN="uid=admin,cn=admins,cn=system"
#password=testadmin
scope="one"
host=$1
uid=$2

shift 2

ldapsearch -x -D $DN -w $password -H $host -s $scope "(objectClass=UMSConfigItem)" $*
