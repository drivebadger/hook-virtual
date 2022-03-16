#!/bin/sh

type=$1
host=$2

# If you want to just copy the image, without compression at all, just leave $4 here.
# If you want to compress it, add extension, that matches compression program used below.
#target=$4.gz
target=$4.lz4

logger "copying $type=$host (to raw image $target)"

# Choose the best compression method:
# - lz4 - the fastest, minimal memory footprint, still achieves very good compression ratio
# - gzip - the most compatible and universal, quite fast
# - pigz - multi-core alternative to gzip (best performance when compressing small number of images on big CPUs, but problematic otherwise)
# - xz - the best compression, but very slow (impractical in most cases)
# - bzip2 - very good compression (worse than xz/lzma2), still very slow
#
# In most cases you should use either lz4 or gzip.
#
# Performance comparison for 80GB Solaris 11 drive image, compressed on Core i7-3770:
# - "lz4 -1" - 12 minutes
# - "gzip -6" - 31 minutes
# - size difference: ~0.8GB (1%)
#
#cat "$3" |gzip -6c >$target
cat "$3" |lz4 -z1c >$target

logger "copied $type=$host"
