#!/bin/sh
cd ~/src/spserver
./clean.sh
cd -
cd ~/src/spcommon
./clean.sh server
cd -
cd ~/src/splibs
./clean.sh server
cd -
rm -rf ~/umsinstaller/ ~/ums/ ~/.umspkg
rm -rf ~/src/spcommon/{bin_debug,bin_release,obj}
rm -rf ~/src/spserver/{bin_debug,bin_release,obj}
