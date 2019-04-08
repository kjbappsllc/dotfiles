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
sleep 2
bot "I am going to be configuring your system for you."
bot "Please stay here so you can enter some passwords and answer some questions for me!"
bot "Don't worry, I am clean and won't do anything with them."
sleep 2

# ###########################################################
# Pre Homebrew installations
# ###########################################################
bot "Configuring command line build tools"
running "checking xcode build tools ..."
xcode-select --install > /dev/null 2>&1
if [[ $? == 0 ]]; then
    info "They are not installed, please follow through with the steps."
    info "Also, please enter your password."
    sudo xcode-select -s /Applications/Xcode.app/Contents/Developer > /dev/null 2>&1
    sudo xcodebuild -license accept > /dev/null 2>&1
    ok "command line build tools are installed"
else
    info "command line build tools are already installed"
fi
sleep 0.5

# ###########################################################
# Homebrew Installation and configuration
# ###########################################################
bot "Configuring Homebrew"
running "checking homebrew..."
brew_bin=$(command -v brew) 2>&1 > /dev/null

if [[ $? != 0 ]]; then
    info "homebrew is not installed"
    action "installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [[ $? != 0 ]]; then
        error "unable to install homebrew, aborting!"
    fi
    ok "homebrew is installed"
else
    info "homebrew is already installed"
    action "updating homebrew"
    brew update
    ok "brew is updated"
    action "upgrading current packages"
    brew upgrade
    ok "brew packages are upgraded"
fi
