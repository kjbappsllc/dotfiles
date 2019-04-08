# ###########################################################
# Variable Initializations
# ###########################################################
DOTFILES_DIR := $(shell echo $(HOME)/dotfiles)
SHELL        := /bin/sh
OSNAME       := $(shell uname -s)
USER         := $(shell whoami)

ifeq ($(OSNAME), Darwin)
	OS := macos
else ifeq ($(OSNAME), Linux)
	OS := linux
else ifeq ($(OSNAME), CYGWIN_NT-6.1)
	OS := windows
endif

# ###########################################################
# Main target which kicks off configuration based on OS
# ###########################################################
.PHONY: all install

all: install

install: $(OS)

# ###########################################################
# Targets for showing the usage message
# ###########################################################
.PHONY: help usage
.SILENT: help usage

help: usage

usage:
	@printf "\\n\
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
# ###########################################################
# Targets that kick off OS specific tasks
# ###########################################################
.PHONY: macos

macos:
	@bash ./install.sh
		