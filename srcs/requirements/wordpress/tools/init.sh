#!/bin/sh

set -e

RESET='\033[0m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
BOLD='\033[1m'

printInfo() {
    printf "${BOLD}${CYAN}[INFO] %s ${RESET}\n" "$*"
}

printSuccess() {
    printf "${BOLD}${GREEN}[DONE] %s ${RESET}\n" "$*"
}

cd /var/www/html

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

MYSQL_USER=$(cat /run/secrets/mysql_user)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)

WP_USER=$(cat /run/secrets/wp_user)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

WP_ADMIN_USER=$(cat /run/secrets/wp_admin)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)

MYSQL_USER_MAIL=$(cat /run/secrets/mysql_user_mail)
MYSQL_ADMIN_MAIL=$(cat /run/secrets/mysql_admin_mail)

printSuccess "MariaDB is ready"

if ! wp core is-installed --allow-root 2>/dev/null; then

    printInfo "Downloading WordPress..."

    wp core download --allow-root

    printInfo "Creating wp-config.php..."

    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb:3306" \
        --allow-root

    printInfo "Installing WordPress..."

    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${MYSQL_ADMIN_MAIL}" \
        --allow-root

    printInfo "Creating secondary user..."

    wp user create \
        "${WP_USER}" \
        "${MYSQL_USER_MAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root

    chown -R www-data:www-data /var/www/html

    printSuccess "WordPress installed !"

else

    printInfo "WordPress already installed and configured."

fi

sed -i \
's|listen = 127.0.0.1:9000|listen = 0.0.0.0:9000|g' \
/etc/php83/php-fpm.d/www.conf

printSuccess "php-fpm listening on 0.0.0.0:9000"

exec php-fpm83 --nodaemonize