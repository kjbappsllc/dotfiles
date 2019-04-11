# ###########################################################
# Initial Check to see if the command was called from main
# ###########################################################

fromMain "isMain" > /dev/null 2>&1
if [[ $? != 0 ]]; then
    echo -e "\033[1m\nPlease run this script through the main script (bash main.sh). Aborting!\n\033[0m"
    exit 2
fi

# ###########################################################
# Set variables
# ###########################################################
OS=$(uname -s)
USER=$(whoami)
PARENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
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

# Show the ~/Library folder.
chflags nohidden ~/Library
ok "show the Library folder by default"

defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
ok "Disable smart quotes"

defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
ok "Disable smart dashes"

sleep 0.5

# ###########################################################
# Pre Homebrew installations
# ###########################################################
bot "Configuring command line build tools"
running "checking xcode build tools ..."
xcode-select --install > /dev/null 2>&1
if [[ $? == 0 ]]; then
    info "They are not installed, please follow through with the steps."
    echo -e "\033[1m\nPress ENTER when you have finished installing\033[0m"
    read
    sudoPrompt "xcode-select --switch /Library/Developer/CommandLineTools" "need password to setup build tools"
    if [[ $? != 0 ]]; then
        error "could not install command line tools. Aborting!"
        exit 2
    fi
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
# set zsh as the user login shell
running "setting up zsh"
CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
if [[ "$CURRENTSHELL" != "/usr/local/bin/zsh" ]]; then
    action "setting newer homebrew zsh (/usr/local/bin/zsh) as your shell (password required)"
    sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/zsh > /dev/null 2>&1
    ok "changed shell to current zsh"
else
    info "shell is already set to zsh"
fi

running "setting up iterm and related tools"
if [[ ! -d "~/.oh-my-zsh" ]]; then
    action "installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" > /dev/null 2>&1
else
    info "oh-my-zsh is already installed"
fi

if [[ ! -d "~/.oh-my-zsh/custom/themes/powerlevel9k" ]]; then
    action "installing powerlevel theme"
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
else
    info "zsh theme already set"
fi

# Create symlinks
running "creating symlinks"
action "linking bash_profile"
ln -fs ${PARENT_DIR}/../terminal/.bash_profile ${HOME}/.bash_profile
if [[ $? != 0 ]]; then
    error "there was a problem creating a symlink with .bash_profile!"
    exit 2
else
    ok "linked"
fi
action "linking bashrc"
ln -fs ${PARENT_DIR}/../terminal/.bashrc ${HOME}/.bashrc
if [[ $? != 0 ]]; then
    error "there was a problem creating a symlink with .bashrc!"
    exit 2
else
    ok "linked"
fi
action "linking zsh"
ln -fs ${PARENT_DIR}/../terminal/.zshrc ${HOME}/.zshrc
if [[ $? != 0 ]]; then
    error "there was a problem creating a symlink with .bashrc!"
    exit 2
else
    ok "linked"
fi