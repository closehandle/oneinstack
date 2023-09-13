#!/usr/bin/env bash
cd $(dirname "$0")
docker image pull postgres:latest || exit $?

docker container run \
    --ip 192.168.88.253 \
    --env TZ=Asia/Shanghai \
    --env POSTGRES_PASSWORD=oneinstack \
    --name postgresql \
    --detach \
    --volume postgresql:/var/lib/postgresql/data \
    --network oneinstack \
    --restart always \
    --hostname postgresql \
    postgres:latest
exit 0
