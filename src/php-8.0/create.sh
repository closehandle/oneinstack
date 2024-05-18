#!/usr/bin/env bash
docker container rm -f php-8.0-fpm > /dev/null 2>&1

docker container run \
    --ip 192.168.88.113 \
    --env TZ=Asia/Shanghai \
    --name php-8.0-fpm \
    --pull always \
    --detach \
    --volume /data/wwwroot:/data/wwwroot \
    --network oneinstack \
    --restart always \
    closehandle/php:8.0-fpm
exit $?
