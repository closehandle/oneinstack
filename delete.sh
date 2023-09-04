#!/usr/bin/env bash
docker container rm -fv nginx
docker container rm -fv mariadb
docker container rm -fv php-fpm
docker volume prune -af
docker network prune -f

rm -fr /etc/nginx
rm -fr /data
exit 0
