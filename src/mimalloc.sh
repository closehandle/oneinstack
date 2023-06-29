#!/usr/bin/env bash
apt update || exit $?
apt install build-essential cmake -y || exit $?

pushd /opt
rm -fr mimalloc
git clone https://github.com/microsoft/mimalloc -b v2.1.2 --depth 1 --single-branch mimalloc || exit $?
cd mimalloc && mkdir release && cd release

cmake -DCMAKE_BUILD_TYPE='RelWithDebInfo' .. || exit $?
cmake --build . -j$(nproc) || exit $?

cp -f libmimalloc.so.2.1 /usr/local/lib
cd ../.. && rm -fr mimalloc
popd

# echo '/usr/local/lib/libmimalloc.so.2.1' > /etc/ld.so.preload
ldconfig
exit 0
