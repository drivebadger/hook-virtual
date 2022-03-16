#!/bin/sh

export LIBGUESTFS_BACKEND=direct

type=$1
image=$2
basedir=$3
target_root_directory=$4
err=""

host=`basename "$image" .$type |tr ' ' '_'`
subtarget=$target_root_directory/$host-$type
mkdir -p $subtarget

virt-filesystems -a "$image" >$subtarget/filesystems.list 2>$subtarget/filesystems.err

if [ ! -s $subtarget/filesystems.err ]; then
	for FS in `cat $subtarget/filesystems.list`; do

		volume=`echo $FS |sed "s#/dev/##g" |tr '[:upper:]' '[:lower:]' |tr '/' '_'`

		mountpoint=/media/$type-$host-$volume/mnt
		target=$subtarget/$volume
		mkdir -p $mountpoint $target

		if guestmount -a "$image" -m $FS --ro $mountpoint >>$target/rsync.log 2>>$target/rsync.err; then
			/opt/drivebadger/internal/generic/process-hooks.sh $mountpoint $target_root_directory

			logger "copying $type=$host/$volume (mounted as $mountpoint, target directory $target)"
			/opt/drivebadger/internal/generic/rsync-partition.sh $mountpoint $target >>$target/rsync.log 2>>$target/rsync.err
			umount $mountpoint
			logger "copied $type=$host/$volume"
		else
			err=$FS
		fi
	done
else
	err="fs"
fi

if [ "$err" != "" ]; then
	/opt/drivebadger/hooks/hook-virtual/helpers/copy-compress.sh $type $host "$image" $subtarget/image.$type &
fi
