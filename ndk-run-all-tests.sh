#!/bin/bash

# Assumptions:
#
#   1) there are AVDs with names armeabi, armeabi-v7a, mips, x86;
#   2) no emulator runs during script execution;
#   3) script run from ndk/platform/ndk dir.
#

FULL=""

while [ -n "$1" ]; do
    opt="$1"
    optarg=`expr "x$opt" : 'x[^=]*=\(.*\)'`
    case "$opt" in
        --help|-h|-\?)
            OPTION_HELP=yes
            ;;
        --full)
            FULL="--full"
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
    echo "    --full            Run long tests too"
    echo ""
    exit 1
fi



TESTS_BUILD_DIR=/tmp/ndk-zuav/tests

RESULTS_BASE_DIR=/var/tmp/ndk.tests.results/
#RESULTS_DIR=/var/tmp/ndk.tests.results/2013.01.22-21:12:40
RESULTS_DIR=/var/tmp/ndk.tests.results/`date +%Y.%m.%d-%H:%M:%S`
GCC_TOOLCHAINS="4.7 4.6 4.4.3"
CLANG_TOOLCHAINS="clang3.1"
ARCHS="armeabi armeabi-v7a mips x86"

# just exit on error
function error_exit ()
{
    cd $OLD_DIR
    echo Failed!
    exit 1
}

mkdir -p $RESULTS_BASE_DIR || error_exit
mkdir    $RESULTS_DIR      || error_exit

for arch in $ARCHS
do
    echo "Starting emulator for $arch"
    emulator -avd $arch &
    adb wait-for-device
    # GCC toolchains
    for toolchain in $GCC_TOOLCHAINS
    do
        echo "Running tests for toolchain GCC-$toolchain"
        LOG_BASE=$arch-gcc-$toolchain
        LOG_FILE=$RESULTS_DIR/$LOG_BASE.txt
        ./tests/run-tests.sh $FULL --abi=$arch --toolchain-version=$toolchain > $LOG_FILE
        cp $TESTS_BUILD_DIR/build-tests.log $RESULTS_DIR/$LOG_BASE.build-tests.log
    done
    # Clang toolchains, currently only one
    for toolchain in $CLANG_TOOLCHAINS
    do
        echo "Running tests for toolchain $toolchain"
        LOG_BASE=$arch-$toolchain
        LOG_FILE=$RESULTS_DIR/$LOG_BASE.txt
        ./tests/run-tests.sh $FULL --abi=$arch --toolchain-version=$toolchain > $LOG_FILE
        cp $TESTS_BUILD_DIR/build-tests.log $RESULTS_DIR/$LOG_BASE.build-tests.log
    done
    echo "Stopping emulator for $arch"
    adb emu kill
    sleep 2
done


echo Done.
exit 0
