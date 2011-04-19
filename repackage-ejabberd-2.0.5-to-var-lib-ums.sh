#!/bin/bash

current_dir=`pwd`
work_dir=/tmp/repack.tmp

mkdir $work_dir
cd $work_dir
tar xf /home/zuav/umsinstaller/pkgs/ums-ejabberd-2.0.5-1.tgz

mkdir -p $work_dir/var/lib/ums

cd ./home/zuav/ums
mv ./var  $work_dir/var/lib/ums
mv ./sbin $work_dir/var/lib/ums
cd -

tar zcf ums-ejabberd-2.0.5-1.tgz ./var
mv ./ums-ejabberd-2.0.5-1.tgz /tmp/
rm -r $work_dir

cd $current_dir
