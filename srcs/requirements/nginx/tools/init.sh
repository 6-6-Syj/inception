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

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
	# To store TLS' keys
    mkdir -p /etc/nginx/ssl

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=CO/ST=REG/L=CITY/O=42/CN=${DOMAIN_NAME}"
    printSuccess "Self-signed TLS certificate successfully generated"

    sed -i "s/server_name localhost/server_name ${DOMAIN_NAME}/g" /etc/nginx/http.d/nginx.conf
    printSuccess "Configured server_name as: ${DOMAIN_NAME}"
fi

printInfo "Starting nginx..."
exec nginx -g "daemon off;"
