#!/usr/bin/env bash
cd $(dirname "$0")
docker image pull redis:alpine || exit $?

docker container run \
    --ip 192.168.88.251 \
    --env TZ=Asia/Shanghai \
    --name redis \
    --detach \
    --network oneinstack \
    --restart always \
    --hostname redis \
    redis:alpine
exit 0
