#!/bin/sh

BDF=0000:01:0a.0

echo -n $BDF > /sys/bus/pci/devices/$BDF/driver/unbind
echo -n $BDF > /sys/bus/pci/drivers/pciback/new_slot
echo -n $BDF > /sys/bus/pci/drivers/pciback/bind
