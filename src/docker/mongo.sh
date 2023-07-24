#!/usr/bin/env bash
cd $(dirname "$0")
docker pull mongo:latest || exit $?

UUID=$(cat /proc/sys/kernel/random/uuid)
docker run \
    --env MONGO_INITDB_ROOT_USERNAME=admin \
    --env MONGO_INITDB_ROOT_PASSWORD=$UUID \
    --name mongo \
    --detach \
    --volume mongo-etcs:/etc/mongo \
    --volume mongo-data:/data/db \
    --restart always \
    --network host \
    mongo:latest || exit $?

echo $UUID
exit 0
