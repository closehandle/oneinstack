#!/usr/bin/env bash
cd $(dirname "$0")
docker container rm -f mariadb
exec ./create.sh
