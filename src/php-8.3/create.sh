#!/usr/bin/env bash
docker container rm -f php-fpm > /dev/null 2>&1

docker container run \
    --ip 192.168.88.101 \
    --env TZ=Asia/Shanghai \
    --name php-fpm \
    --pull always \
    --detach \
    --volume /data/wwwroot:/data/wwwroot \
    --network oneinstack \
    --restart always \
    --hostname php-fpm \
    closehandle/php:8.3-fpm
exit $?
