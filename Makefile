# Getting configuration variables
DOTFILES_DIR := $(shell echo $(HOME)/dotfiles)
SHELL        := /bin/sh
OSNAME        := $(shell uname -s)
USER         := $(shell whoami)

ifeq ($(OSNAME), Darwin)
	OS := macos
else ifeq ($(OSNAME), Linux)
	OS := linux
else ifeq ($(OSNAME), CYGWIN_NT-6.1)
	OS := windows
endif

# Main command to install configurations
.PHONY: all install

all: install

install: $(OS)

# Usage command to display usage message
.PHONY: help usage
.SILENT: help usage

help: usage

usage:
	printf "\\n\
	\\033[1mDOTFILES\\033[0m\\n\
	\\n\
	Custom settings and configurations for Unix-like environments.\\n\
	See README.md for detailed usage information.\\n\
	\\n\
	\\033[1mUSAGE:\\033[0m make [target]\\n\
	\\n\
	  make         Install all configurations and applications.\\n\
	\\n\
	  make link    Symlink only Bash and Vim configurations to the home directory.\\n\
	\\n\
	  make unlink  Remove symlinks created by \`make link\`.\\n\
	\\n\
	"
# OS Specific configurations
.PHONY: macos

macos: brew

# Util commands
.PHONY: brew

brew:
		@if [[ $(shell command -v brew) == "" ]]; then\
    		echo "Homebrew not found, installing ...";\
    		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";\
		else\
    		echo "Homebrew found, updating ...";\
    		brew update;\
		fi
		