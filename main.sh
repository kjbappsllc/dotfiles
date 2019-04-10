#!/usr/bin/env bash

fromMain() {
	echo "${1}"
}

getParentDir() {
    echo $( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
}

OSNAME=$(uname -s)

if [[ ${OSNAME} = "Darwin" ]]; then
	source ./macos/install.sh
else
	echo "Only MAC is supported at the moment. Apologies."
fi