#!/usr/bin/env bash
cd $(dirname "$0")
docker container rm -f mongodb
exec ./create.sh
