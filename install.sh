# ###########################################################
# Source all util files
# ###########################################################
for file in ./utils/*; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# ###########################################################
# Set variables
# ###########################################################
OS=$(uname -s)
USER=$(whoami)
BOTNAME="Jeeves"

# ###########################################################
# Intro
# ###########################################################
bot "Hi ${USER}, im ${BOTNAME}"
sleep 0.5
bot "I am going to be configuring your system for you."
