#!/usr/bin/env bash
docker container rm -f redis > /dev/null 2>&1

docker container run \
    --ip 192.168.88.250 \
    --env TZ=Asia/Shanghai \
    --name redis \
    --pull always \
    --detach \
    --network oneinstack \
    --restart always \
    --hostname redis \
    redis:6.2-alpine
exit $?
