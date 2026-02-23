#!/usr/bin/env zsh

# Install Homebrew's casks in global applications
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Use config dir for Homebrew
export HOMEBREW_BUNDLE_FILE_GLOBAL="$XDG_CONFIG_HOME/brewfile"

# Use config dir for git
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/config"

# Use config dir for GnuPG
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

# Use config dir for Codex
export CODEX_HOME="$XDG_CONFIG_HOME/codex"

# Keep dotfiles git structure in projects dir
export DOTFILES_GIT="$HOME/projects/dotfiles.git"

# Configure Android's SDK to run builds without the need for local.properties
export ANDROID_HOME="$HOME/Library/Android/sdk"

# Use config dir for Bartib
export BARTIB_FILE="$XDG_CONFIG_HOME/secret/bartib.txt"

# Source private environment variables
source "$XDG_CONFIG_HOME/secret/env"

# Homebrew variables
eval "$(/opt/homebrew/bin/brew shellenv)"

# Initialize Atuin
eval "$(atuin init zsh)"

# Initialize rbenv
eval "$(rbenv init - --no-rehash zsh)"

# Initialize pyenv
eval "$(pyenv init - zsh)"

# Initialize nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

# Initialize Rust
source "$HOME/.cargo/env"
