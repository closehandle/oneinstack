#!/usr/bin/env bash
cd $(dirname "$0")
docker image pull closehandle/php:8.2-alpine-fpm || exit $?

docker container run \
    --ip 192.168.88.101 \
    --env TZ=Asia/Shanghai \
    --name php-fpm \
    --detach \
    --volume /data/wwwroot:/data/wwwroot \
    --network oneinstack \
    --restart always \
    --hostname php-fpm \
    closehandle/php:8.2-alpine-fpm \
    php-fpm -R
exit 0
