#!/bin/sh

# COLORS
RESET='\033[0m';
CYAN='\033[0;36m';
GREEN='\033[0;32m';
BOLD='\033[1m';

# PRINT
printInfo()  { printf "${BOLD}${CYAN}[INFO] %s ${RESET}\n" "$*"; }
printSuccess()  { printf "${BOLD}${GREEN}[DONE] %s ${RESET}\n" "$*"; }

set -e

MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_USER=$(cat /run/secrets/mysql_user)

if [ ! -d "/var/lib/mysql/mysql" ]; then
    rm -rf /var/lib/mysql/*

#^ MariaDB installation
	printInfo "Installing MariaDB..."
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql

#^ Starting MariaDB
#* We start mariadb only to configure it. We want to prevent any external access, 
#* since the db is not configured and since root has no password yet,
#* -skip-networking prevents port 3306 to enable and allow extern access during the db configuration
	printInfo "Starting MariaDB."
	/usr/bin/mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking &
	until mariadb-admin ping -h localhost -uroot > /dev/null 2>&1; do
		printInfo "Waiting for MariaDB..."
		sleep 2
	done

	printSuccess "MariaDB is now running !"
	printInfo "Starting configuration..."

	#* Root password
	mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY'${MYSQL_ROOT_PASSWORD}';" \
	&& printSuccess "Root password configured."

	#* Create DB
	mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e \
	"CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;" \
	&& printSuccess "Database created."

	#* Create wordpress user
    mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e \
	"CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' \
	IDENTIFIED BY '${MYSQL_PASSWORD}';" \
	&& printSuccess "User ${MYSQL_USER} created."

	#* Set the user as admin
	mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e \
	"GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';" \
	&& printSuccess "User ${MYSQL_USER} got admin privileges."

	#* Applying privileges change
	mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;" \
	&& printSuccess "Privileges changes applied."

	#^ Since we configured mariadb, we want to shut it down, so exec at the end of this script
	#* will use the process executing this script, as the one executing the mariadb
	mariadb-admin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown \
	&& printSuccess "MariaDB successfully configured !"
fi

#^ We want the process executing this script as entrypoint for the container, to execute and handle mariadb now.
#^ It must keep running in a container, the execution of the entrypoint /init.sh makes this process PID 1 
#^ (which is normally /sbin/init, the parent of all other process) using exec,
#^ We replace PID 1 = /init.sh to PID 1 = /usr/bin/mariadb, thus, there is only one PID running in our container, it runs mariadb.
exec /usr/bin/mariadbd  --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0 --port=3306 --skip-networking=0