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

apt update
exit 0
