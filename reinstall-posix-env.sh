#!/bin/bash

./crew make-posix-env --top-dir=/var/tmp/posix --abi=arm64-v8a --no-check-shasum --with-packages=apt,dpkg,gnu-pg

adb shell rm -rf /data/local/tmp/posix*
adb push /var/tmp/posix.tar.bz2 /data/local/tmp/
adb shell tar xj -C /data/local/tmp -f /data/local/tmp/posix.tar.bz2
adb shell /data/local/tmp/posix/usr/bin/coreutils-create-symlinks.sh
adb push /Users/zuav/tmp/apt/sources.list /data/local/tmp/posix/etc/apt/
adb push /Users/zuav/tmp/apt/apt.conf /data/local/tmp/posix/etc/apt/
adb push /Users/zuav/tmp/apt/status /data/local/tmp/posix/var/lib/dpkg/
