#!/usr/bin/env bash
cd $(dirname "$0")
docker container rm -f nginx > /dev/null 2>&1

if [[ ! -d /etc/nginx ]]; then
    apt update || exit $?
    apt install logrotate -y || exit $?

    docker container run \
        --rm \
        --env TZ=Asia/Shanghai \
        --tty \
        --name nginx \
        --volume /etc:/opt \
        --hostname nginx \
        --interactive \
        closehandle/nginx:latest \
        cp -fr /etc/nginx /opt

    IP=$(curl -4fsSL ip.sb)
    openssl req -x509 -newkey ec:<(openssl ecparam -name secp384r1) -sha384 -days 3650 -nodes \
        -keyout default.key -out default.crt -subj "/CN=${IP}" \
        -addext "subjectAltName=IP:${IP}"
    openssl dhparam -out ffdhe2048.txt 2048
    chmod 0644 default.crt default.key

    cp -f  ../../etc/nginx/fastcgi.conf /etc/nginx
    cp -f  ../../etc/nginx/vhost.conf   /etc/nginx
    cp -fr ../../etc/nginx/rewrite      /etc/nginx/rewrite
    cp -fr ../../etc/nginx/ssl          /etc/nginx/ssl
    cp -f  nginx.conf    /etc/nginx
    mv -f  ffdhe2048.txt /etc/nginx
    mv -f  default.crt   /etc/nginx/ssl/default.crt
    mv -f  default.key   /etc/nginx/ssl/default.key
    rm -fr /etc/nginx/conf.d
    rm -fr /etc/nginx/modules
    rm -f  /etc/nginx/*_params
    rm -f  /etc/nginx/*.default
fi

cat > /etc/logrotate.d/nginx << EOF
/data/wwwlogs/*nginx.log {
    daily
    rotate 7
    dateext
    compress
    missingok
    notifempty
    sharedscripts
    postrotate
        docker container restart nginx
    endscript
}
EOF

docker container run \
    --ip 192.168.88.100 \
    --env TZ=Asia/Shanghai \
    --name nginx \
    --pull always \
    --detach \
    --volume /etc/nginx:/etc/nginx \
    --volume /data/wwwlogs:/data/wwwlogs \
    --volume /data/wwwroot:/data/wwwroot \
    --network oneinstack \
    --restart always \
    --hostname nginx \
    closehandle/nginx:latest
exit $?
