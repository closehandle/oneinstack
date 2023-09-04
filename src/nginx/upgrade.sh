#!/usr/bin/env bash
docker container rm -f nginx
exec ./create.sh
exit 0
