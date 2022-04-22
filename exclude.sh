#!/bin/sh

base=$1

/opt/drivebadger/hooks/hook-virtual/helpers/is-slow-processing-allowed.sh $base || exit 0

echo -n " --exclude-from=/opt/drivebadger/hooks/hook-virtual/exclude.list"
