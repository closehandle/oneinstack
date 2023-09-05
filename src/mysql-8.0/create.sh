#!/usr/bin/env bash
cd $(dirname "$0")
docker image pull mysql:8.0 || exit $?

docker container run \
    --ip 192.168.88.254 \
    --env TZ=Asia/Shanghai \
    --env MYSQL_RANDOM_ROOT_PASSWORD=yes \
    --name mysql \
    --detach \
    --volume mysql:/var/lib/mysql \
    --network oneinstack \
    --restart always \
    --hostname mysql \
    mysql:8.0
exit 0
