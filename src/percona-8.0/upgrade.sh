#!/usr/bin/env bash
cd $(dirname "$0")
docker container rm -f percona
exec ./create.sh
