#!/bin/bash

old_dir=`pwd`
build_dir=~/tmp/oncam-`date +%s`
src_dir=$build_dir/oncam-mobile-development
repo="git@github.com:oncam/oncam-mobile-development.git"

mkdir $build_dir
cd $build_dir
git clone $repo
cd $src_dir
./vendors.sh
cd ./android
cp local.mk.sample local.mk
make

cd $old_dir
