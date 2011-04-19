#!/bin/sh
diff -x '.svn' -w -q -r $1 $2
