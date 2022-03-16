#!/bin/bash

base=$1
target_root_directory=$2

# "find" command is veeery slooow, when run inside directories mounted by qemu/guestmount,
# especially inside VHDX - this is because "find" needs to call stat() function separately
# for each file within given $base directory - so running "find" can take 3-4x more time
# than rsyncing all contents.
#
# at the same time nested virtualization using VMDK/VHDX images is quite unusual
# (all popular solutions based on nested virtualization use different file extensions)

if [[ "$base" == "/media/vhd-"*  ]] && [ ! -f /opt/drivebadger/config/.allow-nested-vhd  ]; then exit 0; fi
if [[ "$base" == "/media/vhdx-"* ]] && [ ! -f /opt/drivebadger/config/.allow-nested-vhdx ]; then exit 0; fi
if [[ "$base" == "/media/vmdk-"* ]] && [ ! -f /opt/drivebadger/config/.allow-nested-vmdk ]; then exit 0; fi


# why +10M requirement below?
# there are 2 types of VMDK files:
# - small text files
# - big binary files (actual partition images)
#
# now, there are 2 types of VMware systems:
#
# - classic ESXi, which uses both files: small text files contain path to the bigger ones,
#   eg. test.local.vmdk (small descriptor file) and test.local-flat.vmdk (actual image)
#
# - some versions of vSphere, that apparently use directly images, without descriptor files,
#   with different naming scheme: test.local.vmdk, test.local_1.vmdk, test.local_2.vmdk etc.
#
# so, for the first case, it would be better to match only -iname '*-flat.vmdk', and then
# exclude *-flat.vmdk files in exclude-virtual configuration repository. but this wouldn't
# work properly on big vSphere installations.

find "$base" -type f -size +10M -iname '*.vmdk' |while read line; do
	logger "found VMDK volume \"$line\""
	# don't execute these tasks directly, but add them to task spooler queue. task spooler
	# will run the first added task immediately, while the next ones will have to wait.
	tsp /opt/drivebadger/hooks/hook-virtual/handle-image.sh vmdk "$line" "$base" $target_root_directory
done

find "$base" -type f -size +1M -iname '*.vhdx' |while read line; do
	logger "found VHDX volume \"$line\""
	tsp /opt/drivebadger/hooks/hook-virtual/handle-image.sh vhdx "$line" "$base" $target_root_directory
done

find "$base" -type f -size +1M -iname '*.vhd' |while read line; do
	logger "found VHD volume \"$line\""
	tsp /opt/drivebadger/hooks/hook-virtual/handle-image.sh vhd "$line" "$base" $target_root_directory
done
