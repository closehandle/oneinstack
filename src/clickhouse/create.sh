#!/usr/bin/env bash
cd $(dirname "$0")
docker image pull clickhouse/clickhouse-server:latest || exit $?

docker container run \
    --ip 192.168.88.252 \
    --env TZ=Asia/Shanghai \
    --name clickhouse \
    --detach \
    --volume clickhouse:/var/lib/clickhouse \
    --ulimit NOFILE=262144:262144 \
    --network oneinstack \
    --restart always \
    --hostname clickhouse \
    clickhouse/clickhouse-server:latest
exit 0
