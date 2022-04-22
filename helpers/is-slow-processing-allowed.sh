#!/bin/bash

base=$1

# "find" command is veeery slooow, when run inside directories mounted by qemu/guestmount,
# especially inside VHDX - this is because "find" needs to call stat() function separately
# for each file within given $base directory - so running "find" can take 3-4x more time
# than rsyncing all contents.
#
# at the same time nested virtualization using VMDK/VHDX images is quite unusual
# (all popular solutions based on nested virtualization use different file extensions)

if [[ "$base" == "/media/vhd-"*  ]] && [ ! -f /opt/drivebadger/config/.allow-nested-vhd  ]; then exit 1; fi
if [[ "$base" == "/media/vhdx-"* ]] && [ ! -f /opt/drivebadger/config/.allow-nested-vhdx ]; then exit 1; fi
if [[ "$base" == "/media/vmdk-"* ]] && [ ! -f /opt/drivebadger/config/.allow-nested-vmdk ]; then exit 1; fi

exit 0
