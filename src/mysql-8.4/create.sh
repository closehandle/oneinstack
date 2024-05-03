#!/usr/bin/env bash
docker container rm -f mysql > /dev/null 2>&1

docker container run \
    --ip 192.168.88.254 \
    --env TZ=Asia/Shanghai \
    --env MYSQL_RANDOM_ROOT_PASSWORD=yes \
    --name mysql \
    --pull always \
    --detach \
    --volume mysql:/var/lib/mysql \
    --network oneinstack \
    --restart always \
    --hostname mysql \
    mysql:8.4
exit $?
