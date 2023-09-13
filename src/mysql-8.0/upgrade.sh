#!/usr/bin/env bash
cd $(dirname "$0")
docker container rm -f mysql
exec ./create.sh
