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
bot "Hi ${USER}, i'm ${BOTNAME}"
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
info "need password to change theme to dark ..."
sudo defaults write /Library/Preferences/.GlobalPreferences AppleInterfaceTheme Dark
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
    brew update > /dev/null 2>&1
    ok "brew is updated"
    action "upgrading current packages"
    brew upgrade > /dev/null 2>&1
    ok "brew packages are upgraded"
fi

running "installing brew packages ..."
brew bundle --file=./macos/.Brewfile
