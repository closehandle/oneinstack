#!/usr/bin/env bash
docker container rm -f mariadb
exec ./create.sh
exit 0
