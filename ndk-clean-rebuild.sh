#!/bin/bash

SYSTEMS="linux-x86"
OLD_DIR=`pwd`

while [ -n "$1" ]; do
    opt="$1"
    optarg=`expr "x$opt" : 'x[^=]*=\(.*\)'`
    case "$opt" in
        --help|-h|-\?)
            OPTION_HELP=yes
            ;;
        --win-too)
            SYSTEMS="linux-x86,windows"
            ;;
        *)
            echo "Unrecognized option: " "$opt"
            exit 1
            ;;
    esac
    shift
done

if [ "$OPTION_HELP" = "yes" ] ; then
    echo "Usage: $0 [options]"
    echo ""
    echo "Valid options:"
    echo ""
    echo "    --help|-h|-?      Print this help"
    echo "    --win-too         Build windows version too"
    echo ""
    exit 1
fi

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

cd /tmp/$NDK_DIR/
PKG_DIR=`ls *.tar.bz2 | awk '{ split($0, a, "-"); print a[1] "-" a[2] "-" a[3]; }'`

mkdir /tmp/$NDK_DIR/package
cd /tmp/$NDK_DIR/package
tar xf ../android-ndk-*-linux-x86.tar.bz2
cd /tmp/$NDK_DIR/package/$PKG_DIR
./tests/standalone/run-all.sh


cd $OLD_DIR
