#!/usr/bin/env bash
cd $(dirname "$0")
docker image pull closehandle/php:7.4-fpm-alpine || exit $?

docker container run \
    --ip 192.168.88.101 \
    --env TZ=Asia/Shanghai \
    --name php-fpm \
    --detach \
    --volume /data/wwwroot:/data/wwwroot \
    --network oneinstack \
    --restart always \
    --hostname php-fpm \
    closehandle/php:7.4-fpm-alpine \
    php-fpm -R
exit 0
