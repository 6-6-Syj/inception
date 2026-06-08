#!/bin/sh

# COLORS
RESET='\033[0m';
CYAN='\033[0;36m';
BOLD='\033[1m';
GREEN='\033[0;32m';

# PRINT
printInfo()  { printf "${BOLD}${CYAN}[INFO] %s ${RESET}\n" "$*"; }
printSuccess()  { printf "${BOLD}${GREEN}[DONE] %s ${RESET}\n" "$*"; }