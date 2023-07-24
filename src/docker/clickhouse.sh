#!/usr/bin/env bash
cd $(dirname "$0")
docker pull clickhouse/clickhouse-server:latest-alpine || exit $?
docker run \
    --name clickhouse \
    --detach \
    --volume clickhouse-etcs:/etc/clickhouse-server \
    --volume clickhouse-data:/var/lib/clickhouse \
    --volume clickhouse-logs:/var/log/clickhouse-server \
    --restart always \
    --network host \
    clickhouse/clickhouse-server:latest-alpine || exit $?
exit 0
