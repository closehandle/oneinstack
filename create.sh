#!/usr/bin/env bash
bash ./src/nginx.sh || exit $?
bash ./src/php-8.2.sh || exit $?
bash ./src/mariadb-10.11.sh || exit $?
exit 0
