#!/usr/bin/env bash
cd $(dirname "$0")

if [[ ! -d /etc/nginx ]]; then
    apt update || exit $?
    apt install logrotate -y || exit $?

    docker container run \
        --rm \
        --env TZ=Asia/Shanghai \
        --tty \
        --volume /etc:/opt \
        --interactive \
        openresty/openresty:latest \
        cp -fr /usr/local/openresty/nginx/conf /opt/nginx

    IP=$(curl -4fsSL ip.sb)
    openssl req -x509 -newkey ec:<(openssl ecparam -name secp384r1) -sha384 -days 3650 -nodes \
        -keyout default.key -out default.crt -subj "/CN=${IP}" \
        -addext "subjectAltName=IP:${IP}"
    chmod 0644 default.crt default.key

    cp -f  ../../etc/nginx/fastcgi.conf /etc/nginx
    cp -f  ../../etc/nginx/vhost.conf   /etc/nginx
    cp -fr ../../etc/nginx/rewrite      /etc/nginx/rewrite
    cp -fr ../../etc/nginx/ssl          /etc/nginx/ssl
    cp -f  nginx.conf  /etc/nginx
    mv -f  default.crt /etc/nginx/ssl/default.crt
    mv -f  default.key /etc/nginx/ssl/default.key
    rm -fr /etc/nginx/conf.d
    rm -fr /etc/nginx/modules
    rm -f  /etc/nginx/*_params
    rm -f  /etc/nginx/*.default
fi

[[ ! -d /data ]] && mkdir /data
[[ ! -d /data/wwwroot ]] && mkdir /data/wwwroot
[[ ! -d /data/wwwroot/default ]] && mkdir /data/wwwroot/default
[[ ! -d /etc/nginx/vhost ]] && mkdir /etc/nginx/vhost

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
        docker container exec nginx nginx -s reopen
    endscript
}
EOF

exit 0
