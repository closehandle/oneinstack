#!/usr/bin/env bash
cd $(dirname "$0")
docker image pull nginx:alpine || exit $?

if [[ ! -d /etc/nginx ]]; then
    docker container run \
        --rm \
        --env TZ=Asia/Shanghai \
        --tty \
        --name nginx \
        --volume /etc:/opt \
        --hostname nginx \
        --interactive \
        nginx:alpine \
        cp -fr /etc/nginx /opt

    IP=$(curl -4fsSL ip.sb)
    openssl req -x509 -newkey ec:<(openssl ecparam -name secp384r1) -sha384 -days 3650 -nodes \
        -keyout default.key -out default.crt -subj "/CN=${IP}" \
        -addext "subjectAltName=IP:${IP}"
    openssl dhparam -out ffdhe2048.txt 2048
    chmod 0644 default.crt default.key

    mv -f  ffdhe2048.txt /etc/nginx
    cp -f  fastcgi.conf  /etc/nginx
    cp -f  nginx.conf    /etc/nginx
    cp -f  vhost.conf    /etc/nginx
    cp -fr rewrite       /etc/nginx/rewrite
    cp -fr ssl           /etc/nginx/ssl
    mv -f  default.crt   /etc/nginx/ssl/default.crt
    mv -f  default.key   /etc/nginx/ssl/default.key
    rm -fr /etc/nginx/conf.d
    rm -fr /etc/nginx/modules
    rm -f  /etc/nginx/*_params
fi

docker container run \
    --ip 192.168.88.100 \
    --env TZ=Asia/Shanghai \
    --name nginx \
    --detach \
    --volume /etc/nginx:/etc/nginx \
    --volume /data/wwwlogs:/data/wwwlogs \
    --volume /data/wwwroot:/data/wwwroot \
    --network oneinstack \
    --restart always \
    --hostname nginx \
    nginx:alpine
exit 0
