#!/bin/sh

vmdk=$1
basedir=$2
target_root_directory=$3

vmdkhost=`echo "$vmdk" |rev |cut -d'/' -f1 |cut -d'.' -f2- |rev |tr ' ' '_'`
mountpoint=/media/vmdk-$vmdkhost/mnt
subtarget=$target_root_directory/$vmdkhost-vmdk/rootfs
mkdir -p $mountpoint $subtarget

if LIBGUESTFS_BACKEND=direct guestmount -a "$vmdk" -i --ro $mountpoint >>$subtarget/rsync.log 2>>$subtarget/rsync.err; then
	logger "copying VMDK=$vmdkhost (mounted as $mountpoint, target directory $subtarget)"
	/opt/drivebadger/internal/generic/rsync-partition.sh $mountpoint $subtarget >>$subtarget/rsync.log 2>>$subtarget/rsync.err
	umount $mountpoint
	logger "copied VMDK=$vmdkhost"
fi
