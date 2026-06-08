#!/bin/sh

MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# -h: host, -u: user, -p:password
mariadb-admin ping -h localhost -uroot -p"${MYSQL_ROOT_PASSWORD}"