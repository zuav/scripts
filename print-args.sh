#!/bin/sh
time=`date`
ind=0
echo $time " print-args.sh run with args:"
for i in $* ; do printf "arg[$ind] = %s\n" $i ; ind=$(($ind + 1)) ; done

