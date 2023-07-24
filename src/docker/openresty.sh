#!/usr/bin/env bash
cd $(dirname "$0")
docker pull openresty/openresty:alpine || exit $?
docker run \
    --rm \
    --volume /usr/local/openresty:/opt/conf \
    openresty/openresty:alpine \
    cp -fr /usr/local/openresty/nginx/conf /opt || exit $?

mkdir -p /data/wwwlogs
mkdir -p /data/wwwroot/default
chown -R root:root /data

rm -f  /usr/local/openresty/*.default
rm -f  /usr/local/openresty/*_params

cp -fr ../../data/rewrite /usr/local/openresty
cp -fr ../../data/ssl     /usr/local/openresty

openssl dhparam -out /usr/local/openresty/ffdhe2048.txt 2048

pushd /usr/local/openresty/ssl
openssl req -x509 -newkey ec:<(openssl ecparam -name secp384r1) -sha384 -days 3650 -nodes \
    -keyout default.key -out default.crt -subj "/CN=`curl -4fsSL ip.sb`" \
    -addext "subjectAltName=IP:`curl -4fsSL ip.sb`"
chmod 0644 *
popd

cat <<EOF>/usr/local/openresty/fastcgi.conf
fastcgi_param SCRIPT_FILENAME   \$document_root\$fastcgi_script_name;
fastcgi_param QUERY_STRING      \$query_string;
fastcgi_param REQUEST_METHOD    \$request_method;
fastcgi_param CONTENT_TYPE      \$content_type;
fastcgi_param CONTENT_LENGTH    \$content_length;

fastcgi_param SCRIPT_NAME       \$fastcgi_script_name;
fastcgi_param REQUEST_URI       \$request_uri;
fastcgi_param DOCUMENT_URI      \$document_uri;
fastcgi_param DOCUMENT_ROOT     \$document_root;
fastcgi_param SERVER_PROTOCOL   \$server_protocol;
fastcgi_param REQUEST_SCHEME    \$scheme;
fastcgi_param HTTPS             \$https if_not_empty;

fastcgi_param GATEWAY_INTERFACE CGI/1.1;
fastcgi_param SERVER_SOFTWARE   nginx/\$nginx_version;

fastcgi_param REMOTE_ADDR       \$remote_addr;
fastcgi_param REMOTE_PORT       \$remote_port;
fastcgi_param SERVER_ADDR       \$server_addr;
fastcgi_param SERVER_PORT       \$server_port;
fastcgi_param SERVER_NAME       \$server_name;
fastcgi_param REDIRECT_STATUS   200;
EOF

cat <<EOF>/usr/local/openresty/nginx.conf
user root root;
worker_processes auto;

error_log /data/wwwlogs/error_nginx.log crit;
pid /run/nginx.pid;

events {
    worker_connections 16384;
    multi_accept on;
}

http {
    client_body_buffer_size 10m;
    client_header_buffer_size 32k;
    client_max_body_size 1024m;
    default_type application/octet-stream;
    keepalive_time 30s;
    keepalive_timeout 10s;
    large_client_header_buffers 4 32k;
    sendfile on;
    server_names_hash_bucket_size 128;
    server_tokens off;
    tcp_nodelay on;
    tcp_nopush on;
    include /usr/local/openresty/nginx/conf/mime.types;

    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_intercept_errors on;
    fastcgi_read_timeout 120s;
    fastcgi_send_timeout 120s;
    fastcgi_temp_file_write_size 128k;
    fastcgi_connect_timeout 3s;

    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css text/xml application/json application/javascript application/rss+xml application/atom+xml image/svg+xml;

    open_file_cache max=1024 inactive=10s;
    open_file_cache_errors on;
    open_file_cache_min_uses 2;
    open_file_cache_valid 30s;

    log_format customized '[\$time_local] \$request_time - \$remote_addr - "\$request" \$status \$body_bytes_sent';

    server {
        listen 80 fastopen=1;
        listen [::]:80 fastopen=1;
        listen 443 ssl http2 fastopen=1;
        listen [::]:443 ssl http2 fastopen=1;
        ssl_certificate /usr/local/openresty/nginx/conf/ssl/default.crt;
        ssl_certificate_key /usr/local/openresty/nginx/conf/ssl/default.key;
        ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305;
        ssl_dhparam /usr/local/openresty/nginx/conf/ffdhe2048.txt;
        ssl_early_data on;
        ssl_prefer_server_ciphers off;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_session_cache shared:SSL:10m;
        ssl_session_tickets on;
        ssl_session_timeout 2h;
        server_name _;
        access_log /data/wwwlogs/access_nginx.log customized;
        root /data/wwwroot/default;
        index index.html index.php;
        include /usr/local/openresty/nginx/conf/rewrite/cache.conf;

        location = /nginx_status {
            stub_status on;
            access_log off;
            allow 127.0.0.1;
            deny all;
        }

        # location ~ [^/]\.php(/|\$) {
        #     fastcgi_pass unix:/run/php/php8.2-fpm.sock;
        #     fastcgi_index index.php;
        #     fastcgi_param PHP_VALUE open_basedir="/tmp/:/data/wwwroot/default/";
        #     include fastcgi.conf;
        # }
    }

    include /usr/local/openresty/nginx/conf/vhost/*.conf;
}
EOF

docker run \
    --name openresty \
    --detach \
    --volume /data:/data \
    --volume /usr/local/openresty:/usr/local/openresty/nginx/conf \
    --restart always \
    --network host \
    openresty/openresty:alpine || exit $?
exit 0
