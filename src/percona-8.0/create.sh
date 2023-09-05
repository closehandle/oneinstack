#!/usr/bin/env bash
cd $(dirname "$0")
docker image pull percona:8.0 || exit $?

docker container run \
    --ip 192.168.88.254 \
    --env TZ=Asia/Shanghai \
    --env MYSQL_RANDOM_ROOT_PASSWORD=yes \
    --name percona \
    --detach \
    --volume percona:/var/lib/mysql \
    --network oneinstack \
    --restart always \
    --hostname percona \
    percona:8.0
exit 0
