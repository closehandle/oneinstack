#!/usr/bin/env bash
cd $(dirname "$0")
docker image pull redis:alpine || exit $?

docker container run \
    --ip 192.168.88.252 \
    --name redis \
    --detach \
    --network oneinstack \
    --restart always \
    --hostname redis \
    redis:alpine
exit 0