#!/bin/bash

SYSTEMS="linux-x86"

NDK_DIR=ndk-$USER

cd ~/src/ndk/platform/ndk
rm -rf /tmp/$NDK_DIR

./build/tools/make-release.sh --force --systems=$SYSTEMS ~/src/ndk/toolchain

if [ $? != 0 ] 
then
    echo "Build failed."
else
    echo "Build sucessfull. Coping to /var/tmp"
    rm -rf /var/tmp/$NDK_DIR
    cp -r /tmp/$NDK_DIR /var/tmp
fi

cd -
