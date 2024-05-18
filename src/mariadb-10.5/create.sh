#!/usr/bin/env bash
docker container rm -f mariadb > /dev/null 2>&1

docker container run \
    --ip 192.168.88.254 \
    --env TZ=Asia/Shanghai \
    --env MARIADB_RANDOM_ROOT_PASSWORD=yes \
    --name mariadb \
    --pull always \
    --detach \
    --volume mariadb:/var/lib/mysql \
    --network oneinstack \
    --restart always \
    mariadb:10.5
exit $?
