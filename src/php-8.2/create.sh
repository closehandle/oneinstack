#!/usr/bin/env bash
cd $(dirname "$0")
docker image pull php:8.2-fpm-alpine || exit $?
docker buildx build -t php:8.2-fpm-alpine-customized . || exit $?

docker container run \
    --env TZ=Asia/Shanghai \
    --name php-fpm \
    --detach \
    --volume /data/wwwroot:/data/wwwroot \
    --network oneinstack \
    --restart always \
    --hostname php-fpm \
    php:8.2-fpm-alpine-customized \
    php-fpm -R
exit 0
