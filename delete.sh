#!/usr/bin/env bash
docker container rm -fv nginx
docker container rm -fv mariadb
docker container rm -fv php-fpm
docker network prune -f
exit 0
