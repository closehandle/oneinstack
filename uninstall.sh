#!/usr/bin/env bash
apt purge 'nginx*' 'php*' 'mariadb*' --autoremove -y || exit $?

rm -f /etc/apt/sources.list.d/nginx.list
rm -f /etc/apt/preferences.d/99nginx
rm -f /usr/share/keyrings/nginx-archive-keyring.gpg

rm -f /etc/apt/sources.list.d/php.list
rm -f /etc/apt/preferences.d/99php
rm -f /etc/apt/trusted.gpg.d/php.gpg

rm -f /etc/apt/sources.list.d/mariadb.list
rm -f /etc/apt/preferences.d/99mariadb
rm -f /etc/apt/keyrings/mariadb-keyring.pgp

systemctl disable --now mariadb
rm -fr /data/mariadb
rm -fr /usr/local/mariadb
rm -f /etc/my.cnf
rm -f /etc/systemd/system/mariadb.service
userdel -fr mariadb
systemctl daemon-reload

apt update
exit 0
