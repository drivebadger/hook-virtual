#!/bin/bash

type=$1
image=$2

# drop path components starting from "Virtual ", eg. "Virtual Machines", "Virtual Hard Disks"
# eg. Hyper-V/Virtual Hard Disks/CN-BPM_C.vhdx -> Hyper-V/CN-BPM_C.vhdx
#
tmp=`echo "$image" |sed -r -e "s#/Virtual (.*)/#/#g" -e "s#-flat##g" |tr ' ' '_'`
dir=`dirname $tmp`

path=`basename $dir`
name=`basename $tmp .$type`


# default drive in ESXi: VMDK name is the same as hostname (except for "-flat", which is removed above)
# eg. windows-server-2022.home/windows-server-2022.home-flat.vmdk -> windows-server-2022.home
if [ $path = $name ]; then
	echo $name

# Hyper-V multiple drives case: VHDX name contains machine name followed by entered drive letter
# eg. CN-FS01/CN-FS01_D.vhdx -> CN-FS01_D
elif [[ $name == "$path"* ]]; then
	echo $name

# TODO: how to handle overlapping parts of path and name? eg. Primacy2016_SQL/SQL_D.vhdx
# eg. https://unix.stackexchange.com/questions/566591/find-duplicate-repeated-or-unique-words-spanning-across-multiple-lines-in-a-file
# but what should be the minimum detectable length of overlapping parts? are 3 characters enough?
# and what if overlapping parts are deeper inside path/name, not at its start/end?


# default behavior: just merge directory name with image name
else
	echo "${path}_${name}"
fi
