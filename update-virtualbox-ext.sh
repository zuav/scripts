#!/bin/sh

VBOXVERSION=`VBoxManage --version | sed -r 's/([0-9])\.([0-9])\.([0-9]{1,2}).*/\1.\2.\3/'`
cd /tmp
wget -q -N "http://download.virtualbox.org/virtualbox/$VBOXVERSION/Oracle_VM_VirtualBox_Extension_Pack-$VBOXVERSION.vbox-extpack"
sudo VBoxManage extpack install --replace Oracle*.vbox-extpack
cd -
