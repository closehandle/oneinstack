#!/usr/bin/env bash
cd $(dirname "$0")
docker image pull mariadb:10.11 || exit $?

docker container run \
    --ip 192.168.88.254 \
    --env TZ=Asia/Shanghai \
    --env MARIADB_RANDOM_ROOT_PASSWORD=yes \
    --name mariadb \
    --detach \
    --volume mariadb:/var/lib/mysql \
    --network oneinstack \
    --restart always \
    --hostname mariadb \
    mariadb:10.11
exit 0
