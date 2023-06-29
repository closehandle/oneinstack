#!/usr/bin/env bash
apt update || exit $?
apt install libmimalloc2.0 -y || exit $?

echo '/usr/lib/x86_64-linux-gnu/libmimalloc.so.2.0' > /etc/ld.so.preload
ldconfig
exit 0
