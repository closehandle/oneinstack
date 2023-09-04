#!/usr/bin/env bash
docker container rm -f clickhouse
exec ./create.sh
exit 0
