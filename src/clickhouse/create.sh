#!/usr/bin/env bash
docker container rm -f clickhouse > /dev/null 2>&1

docker container run \
    --ip 192.168.88.252 \
    --env TZ=Asia/Shanghai \
    --name clickhouse \
    --pull always \
    --detach \
    --volume clickhouse:/var/lib/clickhouse \
    --ulimit nofile=262144:262144 \
    --cap-add IPC_LOCK \
    --cap-add NET_ADMIN \
    --cap-add SYS_NICE \
    --network oneinstack \
    --restart always \
    --hostname clickhouse \
    clickhouse/clickhouse-server:latest-alpine
exit $?
