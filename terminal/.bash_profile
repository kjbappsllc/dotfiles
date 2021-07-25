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

#Exports
[[ -d /Users/KJB0GK2/Library/Android/sdk ]] && export ANDROID_HOME="/Users/KJB0GK2/Library/Android/sdk"
export PATH=~/Library/Android/sdk/tools:$PATH
export PATH=~/Library/Android/sdk/platform-tools:$PATH

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/KJB0GK2/.sdkman"
[[ -s "/Users/KJB0GK2/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/KJB0GK2/.sdkman/bin/sdkman-init.sh"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
