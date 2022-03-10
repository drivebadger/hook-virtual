#!/bin/sh

base=$1
target_root_directory=$2

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

find $base -type f -size +10M -iname '*.vmdk' |while read line; do
	logger "found VMDK volume \"$line\""
	# uncomment & at the end of next line, and rsync jobs for vmdk filesystems will run parallel:
	# - way faster on smaller installations (less than 15-20 VMs)
	# - but sometimes rsync can randomly fail (and you can lose some important data)
	# - on bigger installations it will certainly fail (the only question is, how big?)
	/opt/drivebadger/hooks/hook-virtual/handle-vmdk.sh "$line" "$base" $target_root_directory # &
done
