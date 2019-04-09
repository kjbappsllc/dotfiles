#!/usr/bin/env bash

# Colors
BLUEB="\033[1;34m"
BLUE="\033[0;34m"
GREENB="\033[1;32m"
YELLOW="\033[0;33m"
YELLOWB="\033[1;33m"
REDB="\033[1;31m"
PURPLEB="\033[1;35m"
BOLD="\033[1m"
NONE="\033[0m"

# Echo Utils
bot () {
    echo -e "\n${BLUEB}{•̃_•̃}${NONE}: ${BOLD}${1}${NONE}"
}

running() {
    echo -e "${YELLOW} ⇒ ${NONE}${1}"
}

ok() {
    echo -e "${GREENB}[ok]${NONE} ${1}"
}

info () {
    echo -e "${PURPLEB}[info]${NONE} ${1}"
}

action () {
    echo -e "${YELLOWB}[action]${NONE} ${1}"
}

error () {
    echo -e "${REDB}[error]${NONE} ${1}"
}
