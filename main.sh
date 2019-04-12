#!/usr/bin/env bash

# ###########################################################
# Source all util files
# ###########################################################
for file in ./install-utils/*; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# ###########################################################
# Method defined to allow other programs to check if they are
# being invoked from this location
# ###########################################################
fromMain() {
	echo "${1}"
}

# ###########################################################
# Variables
# ###########################################################
OSNAME=$(uname -s)
PARENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# ###########################################################
# Main
# ###########################################################
if [[ ${OSNAME} = "Darwin" ]]; then
	source ${PARENT_DIR}/macos/install.sh
else
	echo "Only MAC is supported at the moment. Apologies."
fi