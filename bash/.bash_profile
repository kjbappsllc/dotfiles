
# Source all bash lib files
for file in ~/dotfiles/bash/lib/*; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;