#!/usr/bin/env bash
cd $(dirname "$0")

apt update || exit $?
apt install apt-transport-https ca-certificates dirmngr -y || exit $?

GNUPGHOME=$(mktemp -d)
GNUPGHOME="$GNUPGHOME" gpg --no-default-keyring --keyring /usr/share/keyrings/clickhouse-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8919F6BD2B48D754 || exit $?
rm -r "$GNUPGHOME"
chmod +r /usr/share/keyrings/clickhouse-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/clickhouse-keyring.gpg] https://packages.clickhouse.com/deb stable main" > /etc/apt/sources.list.d/clickhouse.list
echo -e "Package: *\nPin: origin packages.clickhouse.com\nPin: release o=clickhouse\nPin-Priority: 900" > /etc/apt/preferences.d/99clickhouse

apt update || exit $?
apt install clickhouse-server clickhouse-client -y || exit $?
systemctl enable --now clickhouse-server
exit 0
