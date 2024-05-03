#!/usr/bin/env bash
docker container rm -f postgresql > /dev/null 2>&1

docker container run \
    --ip 192.168.88.253 \
    --env TZ=Asia/Shanghai \
    --env POSTGRES_PASSWORD=oneinstack \
    --name postgresql \
    --pull always \
    --detach \
    --volume postgresql:/var/lib/postgresql/data \
    --network oneinstack \
    --restart always \
    --hostname postgresql \
    postgres:13
exit $?
