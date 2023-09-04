#!/usr/bin/env bash
cd $(dirname "$0")
docker pull nginx:alpine || exit $?

IP=$(curl -4fsSL ip.sb)
openssl req -x509 -newkey ec:<(openssl ecparam -name secp384r1) -sha384 -days 3650 -nodes \
    -keyout default.key -out default.crt -subj "/CN=${IP}" \
    -addext "subjectAltName=IP:${IP}"
chmod 0644 default.crt default.key
openssl dhparam -out ffdhe2048.txt 2048

docker build -t nginx:customized . || exit $?

rm -f default.crt
rm -f default.key
rm -f ffdhe2048.txt

docker container run \
    --env TZ=Asia/Shanghai \
    --name nginx \
    --detach \
    --volume /data/wwwlogs:/data/wwwlogs \
    --volume /data/wwwroot:/data/wwwroot \
    --network oneinstack \
    --restart always \
    --hostname nginx \
    nginx:customized
exit 0
