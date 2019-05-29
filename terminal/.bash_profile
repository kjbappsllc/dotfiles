#!/usr/bin/env bash

DOTFILES_DIR=$(dirname -- $(readlink ~/.bash_profile))
# Source all bash lib files
for file in ${DOTFILES_DIR}/lib/*; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

if [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
