#!/usr/bin/env bash
if ! id -u www > /dev/null 2>&1; then
    userdel -fr www > /dev/null 2>&1
    useradd -MU -s /sbin/nologin www > /dev/null 2>&1
fi

wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg || exit $?
echo "deb https://packages.sury.org/php/ `lsb_release -sc` main" > /etc/apt/sources.list.d/php.list
echo -e "Package: *\nPin: origin packages.sury.org\nPin: release o=nginx\nPin-Priority: 900" > /etc/apt/preferences.d/99php
apt update || exit $?
apt install php8.2-fpm -y || exit $?

sed -E -i 's|;date.timezone =.*|date.timezone = Asia/Shanghai|g' /etc/php/8.2/cli/php.ini
sed -E -i 's|;date.timezone =.*|date.timezone = Asia/Shanghai|g' /etc/php/8.2/fpm/php.ini

cat <<EOF>/etc/php/8.2/fpm/pool.d/www.conf
[www]
user = www
group = www
listen = /run/php/php8.2-fpm.sock
listen.owner = www
listen.group = www

pm = dynamic
pm.max_children = 32
pm.start_servers = 4
pm.min_spare_servers = 4
pm.max_spare_servers = 32
pm.max_requests = 128
EOF

systemctl daemon-reload
systemctl enable php8.2-fpm
systemctl restart php8.2-fpm
exit 0
