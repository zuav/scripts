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
CLANG_TOOLCHAINS="clang3.1 clang3.2"
ARCHS=""


# just exit on error
function error_exit ()
{
    echo Failed!
    exit 1
}

mkdir -p $RESULTS_BASE_DIR || error_exit
mkdir    $RESULTS_DIR      || error_exit

# Find all devices
DEVICE_armeabi=
DEVICE_armeabi_v7a=
DEVICE_mips=
DEVICE_x86=

ADB_CMD=`which adb`
if [ -z "$ADB_CMD" ] ; then
    echo "ERROR: adb not found"
    exit 1
fi

# Get list of online devices, turn ' ' in device into '.'
DEVICES=`$ADB_CMD devices | grep -v offline | awk 'NR>1 {gsub(/[ \t]+device$/,""); print;}' | sed '/^$/d' | tr ' ' '.'`
for DEVICE in $DEVICES; do
    # undo previous ' '-to-'.' translation
    DEVICE=$(echo $DEVICE | tr '.' ' ')
    # get arch
    ARCH=`$ADB_CMD -s "$DEVICE" shell getprop ro.product.cpu.abi | tr -dc '[:print:]'`
    case "$ARCH" in
        armeabi-v7a)
            DEVICE_armeabi_v7a=$DEVICE
            ;;
        armeabi)
            DEVICE_armeabi=$DEVICE
            ;;
        x86)
            DEVICE_x86=$DEVICE
            ;;
        mips)
            DEVICE_mips=$DEVICE
            ;;
        *)
            echo "ERROR: Unsupported architecture: $ARCH"
            exit 1
    esac
done

# check that all required devices are present
if [ -z "$DEVICE_armeabi" ] ; then
    echo "ERROR: not found armeabi device/emulator"
    exit 1
fi

if [ -z "$DEVICE_armeabi_v7a" ] ; then
    echo "ERROR: not found armeabi-v7a device/emulator"
    exit 1
fi

if [ -z "$DEVICE_x86" ] ; then
    echo "ERROR: not found x86 device/emulator"
    exit 1
fi

if [ -z "$DEVICE_mips" ] ; then
    echo "ERROR: not found mips device/emulator"
    exit 1
fi

EMULATORS="armeabi:$DEVICE_armeabi armeabi-v7a:$DEVICE_armeabi_v7a x86:$DEVICE_x86 mips:$DEVICE_mips"

for EMU in $EMULATORS
do
    ARCH=${EMU%:*}
    DEVICE=${EMU#*:}
    echo "Starting tests for $ARCH using device $DEVICE"
    # GCC toolchains
    for toolchain in $GCC_TOOLCHAINS
    do
        echo "Running tests for toolchain GCC-$toolchain"
        LOG_BASE=$ARCH-gcc-$toolchain
        LOG_FILE=$RESULTS_DIR/$LOG_BASE.txt
        ANDROID_SERIAL=$DEVICE ./tests/run-tests.sh $FULL --continue-on-build-fail --abi=$ARCH --toolchain-version=$toolchain > $LOG_FILE
        cp $TESTS_BUILD_DIR/build-tests.log $RESULTS_DIR/$LOG_BASE.build-tests.log
    done
    # Clang toolchains
    for toolchain in $CLANG_TOOLCHAINS
    do
        echo "Running tests for toolchain $toolchain"
        LOG_BASE=$ARCH-$toolchain
        LOG_FILE=$RESULTS_DIR/$LOG_BASE.txt
        ANDROID_SERIAL=$DEVICE ./tests/run-tests.sh $FULL --continue-on-build-fail --abi=$ARCH --toolchain-version=$toolchain > $LOG_FILE
        cp $TESTS_BUILD_DIR/build-tests.log $RESULTS_DIR/$LOG_BASE.build-tests.log
    done
done


echo Done.
exit 0
