#!/usr/bin/env bash
docker container rm -f mongodb > /dev/null 2>&1

docker container run \
    --ip 192.168.88.251 \
    --env TZ=Asia/Shanghai \
    --env MONGO_INITDB_ROOT_USERNAME=admin \
    --env MONGO_INITDB_ROOT_PASSWORD=oneinstack \
    --name mongodb \
    --pull always \
    --detach \
    --volume mongodb:/data/db \
    --network oneinstack \
    --restart always \
    --hostname mongodb \
    mongo:7.0
exit $?
