#!/usr/bin/env bash
[[ ! `id -u www 2>/dev/null` ]] && useradd -MU -s /sbin/nologin www

wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg || exit $?
echo "deb https://packages.sury.org/php/ `lsb_release -sc` main" > /etc/apt/sources.list.d/php.list
echo -e "Package: *\nPin: origin packages.sury.org\nPin: release o=nginx\nPin-Priority: 900" > /etc/apt/preferences.d/99php
apt update || exit $?
apt install php7.4-fpm -y || exit $?

sed -E -i 's|^;date.timezone =.*|date.timezone = Asia/Shanghai|g' /etc/php/7.4/cli/php.ini
sed -E -i 's|^;date.timezone =.*|date.timezone = Asia/Shanghai|g' /etc/php/7.4/fpm/php.ini
sed -E -i 's|^post_max_size = .*|post_max_size = 1024M|g' /etc/php/7.4/cli/php.ini
sed -E -i 's|^post_max_size = .*|post_max_size = 1024M|g' /etc/php/7.4/fpm/php.ini
sed -E -i 's|^upload_max_filesize = .*|upload_max_filesize = 1024M|g' /etc/php/7.4/cli/php.ini
sed -E -i 's|^upload_max_filesize = .*|upload_max_filesize = 1024M|g' /etc/php/7.4/fpm/php.ini
sed -E -i 's|^max_execution_time = .*|max_execution_time = 30|g' /etc/php/7.4/cli/php.ini
sed -E -i 's|^max_execution_time = .*|max_execution_time = 30|g' /etc/php/7.4/fpm/php.ini
sed -E -i 's|^short_open_tag = .*|short_open_tag = On|g' /etc/php/7.4/cli/php.ini
sed -E -i 's|^short_open_tag = .*|short_open_tag = On|g' /etc/php/7.4/fpm/php.ini
sed -E -i 's|^expose_php = .*|expose_php = Off|g' /etc/php/7.4/cli/php.ini
sed -E -i 's|^expose_php = .*|expose_php = Off|g' /etc/php/7.4/fpm/php.ini

cat <<EOF>/etc/php/7.4/fpm/pool.d/www.conf
[www]
user = www
group = www
listen = /run/php/php7.4-fpm.sock
listen.backlog = -1
listen.allowed_clients = 127.0.0.1
listen.owner = www
listen.group = www
listen.mode = 0666

pm = dynamic
pm.max_children = 8
pm.start_servers = 8
pm.min_spare_servers = 8
pm.max_spare_servers = 8
pm.process_idle_timeout = 10
pm.max_requests = 128
request_terminate_timeout = 30
request_slowlog_timeout = 0
EOF

systemctl daemon-reload
systemctl enable php7.4-fpm
systemctl restart php7.4-fpm
exit 0
