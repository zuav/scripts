#!/bin/sh
#
# Show files extensions in directory tree.
#
# NB:
#     - when ru with out arguments will start from pwd;
#     - files with '.svn' in their name are excluded;
#     - files with no extension (like Makefile) are just skipped;
#
#
# Alexander Zhukov
#
# Usage:
#
#   show-extensions [path]
#

if [ $# = 0 ]  ; then path=`pwd`; else path=$1; fi
find $path -type f | grep -v '.svn'     | \
awk '{ n1 = split($0, arr1, "/");  \
       str = arr1[n1];             \
       n2 = split(str, arr2, "."); \
       if (n2 == 1) next;          \
       print arr2[n2]; }'               | \
sort                                    | \
uniq
