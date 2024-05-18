#!/usr/bin/env bash
docker container rm -f php-7.4-fpm > /dev/null 2>&1

docker container run \
    --ip 192.168.88.114 \
    --env TZ=Asia/Shanghai \
    --name php-7.4-fpm \
    --pull always \
    --detach \
    --volume /data/wwwroot:/data/wwwroot \
    --network oneinstack \
    --restart always \
    closehandle/php:7.4-fpm
exit $?
