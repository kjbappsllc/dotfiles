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
BOTNAME="Jarvis"

# ###########################################################
# Intro
# ###########################################################
bot "Hi ${USER}, i'm ${BOTNAME}, the macos installer"
sleep 2
bot "I am going to be configuring your system for you."
bot "Please stay here so you can enter some passwords and answer some questions for me!"
bot "Don't worry, I am clean and won't do anything with them."
sleep 1
bot "Starting configuration tasks ..."
sleep 2

# ###########################################################
# System defaults
# ###########################################################
bot "Setting up system defaults"
# Close System Preferences just in case
osascript -e 'tell application "System Preferences" to quit'
ok "closed system preferences"

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
ok "set default to save to disk not iCloud"

# Save screenshots as PNG
defaults write com.apple.screencapture type -string "png"
ok "set screenshots to save as png format"

# Set plain text as default format in TextEdit
defaults write com.apple.TextEdit RichText -int 0
ok "set plain text as default in RichText"

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Bottom left >> Put display to sleep
defaults write com.apple.dock wvous-bl-corner -int 10
defaults write com.apple.dock wvous-bl-modifier -int 0
ok "set bottom left hot corner to put display to sleep"

# Set dark theme
sudoPrompt "defaults write /Library/Preferences/.GlobalPreferences AppleInterfaceTheme Dark" "need password to change theme to dark ..."
ok "set theme to dark theme"

### Safari ###

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
ok "set privacy to not send search queries to apple"
sleep 0.5

# ###########################################################
# Pre Homebrew installations
# ###########################################################
bot "Configuring command line build tools"
running "checking xcode build tools ..."
xcode-select --install > /dev/null 2>&1
if [[ $? == 0 ]]; then
    info "They are not installed, please follow through with the steps."
    sudoPrompt "xcode-select -s /Applications/Xcode.app/Contents/Developer > /dev/null 2>&1" "need password to setup build tools"
    sudoPrompt "xcodebuild -license accept > /dev/null 2>&1" "need password to accept license"
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
        info "check to see if you have the command line tools properly installed"
        exit 2
    fi
    ok "homebrew is installed"
else
    info "homebrew is already installed"
    action "updating homebrew"
    brew update > /dev/null 2>&1
    ok "brew is updated"
    action "upgrading current packages"
    brew upgrade > /dev/null 2>&1
    ok "brew packages are upgraded"
fi

running "installing brew packages ..."
brew bundle --file=./macos/.Brewfile

if [[ $? != 0 ]]; then
    error "there was a problem completing homebrew package installation. aborting!"
    info "check to see if you already have any application that may clash installed already"
    exit 2
fi

# ###########################################################
# Bash and terminal configuration
# ###########################################################
bot "Configuring Bash and Terminal"
running "checking bash_profile"

if [[ -f ${HOME}/.bash_profile ]]; then
    info "bash_profile exists"
else
    info "bash_profile does not exist"
    action "creating bash_profile"
    touch ${HOME}/.bash_profile
    if [[ $? != 0 ]]; then
        error "could not create bash_profile"
        exit 2
    fi
    ok "created bash_profile in home directory"
fi

running "checking bash_rc"
if [[ -f ${HOME}/.bash_rc ]]; then
    info "bash_rc exists"
else
    info "bash_rc does not exist"
    action "creating bash_rc"
    touch ${HOME}/.bash_rc
    if [[ $? != 0 ]]; then
        error "could not create bash_rc"
        exit 2
    fi
    ok "created bash_rc in home directory"
fi
