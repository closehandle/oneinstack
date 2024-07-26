#!/usr/bin/env bash
docker compose rm -fs
docker system prune -af

rm -fr /etc/logrotate.d/nginx /etc/nginx /data
exit 0
