#!/usr/bin/env bash
cd $(dirname "$0")
apt install jq -y || exit $?

docker network create --subnet 192.168.88.0/24 oneinstack || exit $?

mkdir -p /data/wwwlogs
mkdir -p /data/wwwroot/default

./src/mariadb-10.11/create.sh || exit $?
./src/php-8.2/create.sh || exit $?
./src/nginx/create.sh || exit $?

clear
sleep 3
echo '[+] Subnet      : 192.168.88.0/24'
echo '[+] Web Server  : 192.168.88.100'
echo '[+] DB Hostname : 192.168.88.254'
echo '[+] DB Password'   $(docker container logs mariadb 2>&1 | grep 'GENERATED ROOT PASSWORD' | awk -F'GENERATED ROOT PASSWORD' '{print $2}')
exit 0
