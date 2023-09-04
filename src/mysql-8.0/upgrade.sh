#!/usr/bin/env bash
docker container rm -f mysql
exec ./create.sh
exit 0
