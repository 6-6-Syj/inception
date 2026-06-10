#!/bin/sh

set -a
. srcs/.env
set +a

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RESET='\033[0m'

printf "${CYAN}Checking for NGINX...${RESET}\n"

sleep 1
if curl -kLs https://$DOMAIN_NAME | grep -q "$WP_TITLE"; then
    printf "${GREEN}✓ NGINX OK${RESET}\n"
else
    printf "${RED}✗ NGINX KO${RESET}\n"
    exit 1
fi