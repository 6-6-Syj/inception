#!/bin/sh

set -e

# COLORS
RESET='\033[0m';
CYAN='\033[0;36m';
GREEN='\033[0;32m';
BOLD='\033[1m';

# PRINT
printInfo()  { printf "${BOLD}${CYAN}[INFO] %s ${RESET}\n" "$*"; }
printSuccess()  { printf "${BOLD}${GREEN}[DONE] %s ${RESET}\n" "$*"; }

cd /var/www/html/
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
WP_USER=$(cat /run/secrets/wp_user)
WP_ADMIN_USER=$(cat /run/secrets/wp_admin)
MYSQL_USER=$(cat /run/secrets/mysql_user)
MYSQL_ADMIN=$(cat /run/secrets/mysql_admin)
MYSQL_ADMIN_MAIL=$(cat /run/secrets/mysql_admin_mail)
MYSQL_USER_MAIL=$(cat /run/secrets/mysql_user_mail)

printInfo "Waiting for MariaDB ..."
TIME=0
until nc -z mariadb 3306; do
    printInfo "Waiting for MariaDB ... (${TIME}s)"
    TIME=$((TIME + 1))
    sleep 1
done
printSuccess "MariaDB is ready"

if [ ! -f /var/www/html/wp-config.php ]; then

    wp core download --allow-root

    wp config create \
      --dbname="${MYSQL_DATABASE}" \
      --dbuser="${MYSQL_USER}" \
      --dbpass="${MYSQL_PASSWORD}" \
      --dbhost=mariadb:3306 \
      --allow-root
    printSuccess "wp-config.php created."
      
    log_info "Installing WordPress ..."
    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${MYSQL_ADMIN_MAIL}" \
        --allow-root

    wp user create \
        "${WP_USER}" \
        "${MYSQL_USER_MAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root
    printSuccess "user created."

    printSuccess "WordPress successfully installed"
else
    printInfo "WordPress already installed and configured"
fi

sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/' /etc/php83/php-fpm.d/www.conf \
    && printSuccess "php-fpm socket set to 0.0.0.0:9000" \

exec su -s /bin/sh www-data -c "php-fpm83 --nodaemonize --fpm-config /etc/php83/php-fpm.conf"