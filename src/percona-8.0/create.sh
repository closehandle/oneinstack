#!/usr/bin/env bash
docker container rm -f percona > /dev/null 2>&1

docker container run \
    --ip 192.168.88.254 \
    --env TZ=Asia/Shanghai \
    --env MYSQL_RANDOM_ROOT_PASSWORD=yes \
    --name percona \
    --pull always \
    --detach \
    --volume percona:/var/lib/mysql \
    --network oneinstack \
    --restart always \
    --hostname percona \
    percona:8.0
exit $?
