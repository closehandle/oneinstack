#!/usr/bin/env bash
[[ ! `id -u mariadb 2>/dev/null` ]] && useradd -MU -s /sbin/nologin mariadb
mkdir -p /data/mariadb
chown -R mariadb:mariadb /data/mariadb

apt install jq libmimalloc2.0 libncurses5 -y || exit $?

VERSION="10.11"
FILE_NAME=$(curl -fsSL https://downloads.mariadb.org/rest-api/mariadb/$VERSION/ | jq -r 'first(.releases[]).files[] | select(.os == "Linux") | .file_name')
FILE_NAME_TRIMED=$(echo $FILE_NAME | sed 's|.tar.gz||g')
DOWNLOAD_URL=$(curl -fsSL https://downloads.mariadb.org/rest-api/mariadb/$VERSION/ | jq -r 'first(.releases[]).files[] | select(.os == "Linux") | .file_download_url')

pushd /usr/local
wget -O $FILE_NAME $DOWNLOAD_URL || exit $?
tar xf $FILE_NAME && rm -f $FILE_NAME
mv -f $FILE_NAME_TRIMED mariadb
chown -R root:root mariadb
popd

pushd /usr/local/mariadb
./scripts/mariadb-install-db --user=mariadb --basedir=/usr/local/mariadb --datadir=/data/mariadb || exit $?
popd

cat > /etc/my.cnf << EOF
[client]
port = 3306
default-character-set = utf8mb4

[mysqld]
server-id = 1
basedir = /usr/local/mariadb
datadir = /data/mariadb
bind-address = 0.0.0.0
port = 3306

init-connect = 'SET NAMES utf8mb4'
character-set-server = utf8mb4

skip-name-resolve
back_log = 128

max_connections = 2048
max_connect_errors = 4
table_open_cache = 128
max_allowed_packet = 512M
binlog_cache_size = 1M
max_heap_table_size = 8M
tmp_table_size = 16M

read_buffer_size = 2M
read_rnd_buffer_size = 8M
sort_buffer_size = 8M
join_buffer_size = 8M
key_buffer_size = 4M

thread_cache_size = 8

query_cache_type = 1
query_cache_size = 8M
query_cache_limit = 2M

ft_min_word_len = 4

log_bin = mysql-bin
binlog_format = mixed
expire_logs_days = 1

log_error = /data/mariadb/mariadb-error.log
slow_query_log = 1
slow_query_log_file = /data/mariadb/mariadb-slow.log
long_query_time = 1

performance_schema = 0

skip-external-locking

default_storage_engine = InnoDB
innodb_file_per_table = 1
innodb_open_files = 500
innodb_buffer_pool_size = 64M
innodb_write_io_threads = 4
innodb_read_io_threads = 4
innodb_purge_threads = 1
innodb_flush_log_at_trx_commit = 2
innodb_log_buffer_size = 2M
innodb_log_file_size = 32M
innodb_max_dirty_pages_pct = 90
innodb_lock_wait_timeout = 120

bulk_insert_buffer_size = 8M
myisam_sort_buffer_size = 8M
myisam_max_sort_file_size = 10G

interactive_timeout = 28800
wait_timeout = 28800

[mysqldump]
quick
max_allowed_packet = 512M

[myisamchk]
key_buffer_size = 8M
sort_buffer_size = 8M
read_buffer = 4M
write_buffer = 4M
EOF

cat > /etc/systemd/system/mariadb.service << EOF
[Unit]
Description=MariaDB
After=network.target

[Service]
Type=notify
User=mariadb
Group=mariadb
LimitCORE=infinity
LimitNPROC=infinity
LimitNOFILE=infinity
CapabilityBoundingSet=CAP_IPC_LOCK CAP_DAC_OVERRIDE CAP_AUDIT_WRITE
Environment="LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libmimalloc.so.2.0"
ExecStart=/usr/local/mariadb/bin/mariadbd --defaults-file=/etc/my.cnf --basedir=/usr/local/mariadb --datadir=/data/mariadb
Restart=on-abort
RestartSec=3s

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now mariadb

UUID=$(cat /proc/sys/kernel/random/uuid)
/usr/local/mariadb/bin/mariadb -e "GRANT ALL PRIVILEGES ON *.* TO root@'127.0.0.1' IDENTIFIED BY '$UUID' WITH GRANT OPTION;"
/usr/local/mariadb/bin/mariadb -e "GRANT ALL PRIVILEGES ON *.* TO root@'localhost' IDENTIFIED BY '$UUID' WITH GRANT OPTION;"
/usr/local/mariadb/bin/mariadb -uroot -p$UUID -e "DELETE FROM mysql.user WHERE Password='' AND User NOT LIKE 'mariadb.%';"
/usr/local/mariadb/bin/mariadb -uroot -p$UUID -e "DELETE FROM mysql.db Where User='';"
/usr/local/mariadb/bin/mariadb -uroot -p$UUID -e "DELETE FROM mysql.proxies_priv where Host != 'localhost';"
/usr/local/mariadb/bin/mariadb -uroot -p$UUID -e "DROP DATABASE test;"
/usr/local/mariadb/bin/mariadb -uroot -p$UUID -e "RESET MASTER;"

systemctl restart mariadb
echo $UUID
exit 0
