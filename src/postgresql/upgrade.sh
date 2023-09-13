#!/usr/bin/env bash
cd $(dirname "$0")
docker container rm -f postgresql
exec ./create.sh
