#!/usr/bin/env bash

DOTFILES_DIR=$(dirname -- $(readlink ~/.bash_profile))
# Source all bash lib files
for file in ${DOTFILES_DIR}/lib/*; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;