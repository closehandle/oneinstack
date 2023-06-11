#!/usr/bin/env bash
# apt install apt-transport-https wget -y || exit $?
# wget -O /etc/apt/keyrings/mariadb-keyring.pgp https://mariadb.org/mariadb_release_signing_key.pgp || exit $?
# echo "deb [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://mirrors.gigenet.com/mariadb/repo/10.11/debian `lsb_release -sc` main" > /etc/apt/sources.list.d/mariadb.list
# echo -e "Package: *\nPin: origin mirrors.gigenet.com\nPin: release o=mariadb\nPin-Priority: 900" > /etc/apt/preferences.d/99mariadb
apt update || exit $?
apt install mariadb-server -y || exit $?

mysql_secure_installation || exit $?
systemctl restart mysqld
exit 0
