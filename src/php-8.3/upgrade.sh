#!/usr/bin/env bash
cd $(dirname "$0")
docker container rm -f php-fpm
exec ./create.sh
