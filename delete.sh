#!/usr/bin/env bash
apt purge 'nginx*' --autoremove -y
rm -f /etc/apt/sources.list.d/nginx.list
rm -f /etc/apt/preferences.d/99nginx
rm -f /usr/share/keyrings/nginx-archive-keyring.gpg

apt purge 'php*' --autoremove -y
rm -f /etc/apt/sources.list.d/php.list
rm -f /etc/apt/preferences.d/99php
rm -f /etc/apt/trusted.gpg.d/php.gpg

apt purge 'mariadb*' --autoremove -y
rm -f /etc/apt/sources.list.d/mariadb.list
rm -f /etc/apt/preferences.d/99mariadb
rm -f /etc/apt/keyrings/mariadb-keyring.pgp

systemctl disable --now mariadb
rm -f /etc/my.cnf
rm -f /etc/systemd/system/mariadb.service
rm -fr /data/mariadb
rm -fr /usr/local/mariadb
userdel -fr mariadb
systemctl daemon-reload

systemctl disable --now clickhouse-server
apt purge clickhouse-server clickhouse-client --autoremove -y
rm -f /etc/apt/sources.list.d/clickhouse.list
rm -f /etc/apt/preferences.d/99clickhouse
rm -f /etc/security/limits.d/clickhouse.conf
rm -f /usr/share/keyrings/clickhouse-keyring.gpg*
rm -fr /etc/clickhouse-server
rm -fr /var/lib/clickhouse
rm -fr /var/log/clickhouse-server

apt purge 'postgresql-15*' --autoremove -y
apt purge 'postgresql-client-15*' --autoremove -y
rm -f /etc/apt/sources.list.d/pgdg.list
rm -f /etc/apt/trusted.gpg.d/postgresql.gpg
rm -f /etc/apt/preferences.d/99postgresql
rm -fr /etc/postgresql
rm -fr /var/log/postgresql

apt update
exit 0
