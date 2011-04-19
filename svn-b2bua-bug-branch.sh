#!/bin/sh
#
# $1 - bug number
#
# todo:
#    - check params
#    - check if dir for this bug was already created in ~/src
#    - more general, like this: svn-bug-branch.sh spserver b2bua 9999
#

msg="Created branch to fix bug $1."
b2bua_trunk="svn+ssh://azhukov@repository.unison.local/svn/spserver/trunk/b2bua"
b2bua_branch="svn+ssh://azhukov@repository.unison.local/svn/spserver/branches/b2bua-bug$1"
b2bua_working_copy="b2bua-$1"

cd ~/src/spserver
svn copy -m \"\"$msg\"\" $b2bua_trunk $b2bua_branch
svn co $b2bua_branch $b2bua_working_copy
cd -
