#!/usr/bin/env bash
cd $(dirname "$0")
docker image pull mongo:latest || exit $?

docker container run \
    --ip 192.168.88.252 \
    --env TZ=Asia/Shanghai \
    --env MONGO_INITDB_ROOT_USERNAME=admin \
    --env MONGO_INITDB_ROOT_PASSWORD=oneinstack \
    --name mongodb \
    --detach \
    --volume mongodb:/data/db \
    --network oneinstack \
    --restart always \
    --hostname mongodb \
    mongo:latest
exit 0
