#!/bin/sh
#
# Copy contents of the CF card to archive dir
#
#
archive_dir=~/archive/cf
cf_dir=/media/cf
file_to_check=$cf_dir/ignore_my_docs
target_dir=$archive_dir/`date +"%F.%T"`

error_level=0

# check if CF is mounted
if [ ! -f $file_to_check ] ; then
    echo "cf card is not mounted"
    exit 1 
fi

# create target dir
mkdir -p $target_dir
error_level=$?
if [ $error_level != "0" ]; then
    echo "failed to create target dir"
    exit 1
fi

# copy files
cp -r $cf_dir/* $target_dir
error_level=$?
if [ $error_level != "0" ]; then
    echo "failed to copy files"
    exit 1
fi

# fix permissions
chmod -R go-r $target_dir
error_level=$?
if [ $error_level != "0" ]; then
    echo "chmod failed (0)"
    exit 1
fi
find $target_dir -type d | awk '{ print "\"" $0 "\"" }' | xargs chmod go-x
error_level=$?
if [ $error_level != "0" ]; then
    echo "chmod failed (1)"
    exit 1
fi
find $target_dir -type f | awk '{ print "\"" $0 "\"" }' | xargs chmod a-x
error_level=$?
if [ $error_level != "0" ]; then
    echo "chmod failed (2)"
    exit 1
fi
