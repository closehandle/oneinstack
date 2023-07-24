#!/usr/bin/env bash
apt update || exit $?
apt install build-essential autoconf -y || exit $?

pushd /opt
rm -fr jemalloc
git clone https://github.com/jemalloc/jemalloc -b 5.3.0 --depth 1 --single-branch jemalloc || exit $?
cd jemalloc && mkdir release && cd release

./autogen.sh --prefix=/usr/local/jemalloc || exit $?
make -j$(nproc) || exit $?
make install || exit $?
cd .. && rm -fr jemalloc
popd

# echo '/usr/local/jemalloc/lib/libjemalloc.so.2' > /etc/ld.so.preload
ldconfig
exit 0
