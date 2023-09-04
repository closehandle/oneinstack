#!/usr/bin/env bash
docker container rm -f percona
exec ./create.sh
exit 0
