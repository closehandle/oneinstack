#!/usr/bin/env bash
docker container rm -fv nginx
docker container rm -fv mariadb
docker container rm -fv php-fpm
docker network prune -f
docker image prune -af

rm -fr /etc/nginx /data
exit 0
