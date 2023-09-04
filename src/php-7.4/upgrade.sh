#!/usr/bin/env bash
docker container rm -f php-fpm
exec ./create.sh
exit 0
