#!/usr/bin/env bash
apt install gnupg2 -y || exit $?

echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
echo -e "Package: *\nPin: origin www.postgresql.org\nPin: release o=postgresql\nPin-Priority: 900" > /etc/apt/preferences.d/99postgresql

apt update || exit $?
apt install postgresql-15 -y || exit $?
exit 0
