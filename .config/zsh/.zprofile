#!/usr/bin/env zsh

# Dotfiles profile
unset DOTFILES_PROFILE HOMEBREW_DOTFILES_PROFILE

if [[ -r "$XDG_CONFIG_HOME/profile" ]]; then
  DOTFILES_PROFILE="$(<"$XDG_CONFIG_HOME/profile")"

  case "$DOTFILES_PROFILE" in
  home|work)
    export DOTFILES_PROFILE
    export HOMEBREW_DOTFILES_PROFILE="$DOTFILES_PROFILE"
    ;;
  *)
    print -u2 "Invalid DOTFILES_PROFILE=$DOTFILES_PROFILE. Expected 'home' or 'work'."
    unset DOTFILES_PROFILE
    ;;
  esac
fi

# Private environment
set -a
[[ -r "$XDG_CONFIG_HOME/secret/common.env" ]] && source "$XDG_CONFIG_HOME/secret/common.env"
[[ -n "$DOTFILES_PROFILE" && -r "$XDG_CONFIG_HOME/secret/$DOTFILES_PROFILE.env" ]] && source "$XDG_CONFIG_HOME/secret/$DOTFILES_PROFILE.env"
set +a

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Homebrew casks
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Homebrew config
export HOMEBREW_BUNDLE_FILE_GLOBAL="$XDG_CONFIG_HOME/homebrew/brewfile"

# Git config
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/config"

# GnuPG config
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

# Dotfiles git
export DOTFILES_GIT="$HOME/projects/dotfiles.git"

# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"

# Preferred tools
typeset -U path PATH
path=(
  "$HOMEBREW_PREFIX/opt/bash/bin"
  "$HOMEBREW_PREFIX/opt/sqlite/bin"
  "$HOMEBREW_PREFIX/opt/curl/bin"
  "$HOMEBREW_PREFIX/opt/rustup/bin"
  $path
)

# Java defaults
source <(jdk_auto graal)
source <(jdk_auto)

# rbenv
eval "$(rbenv init - --no-rehash zsh)"

# pyenv
eval "$(pyenv init - --no-rehash zsh)"

# nvm
# Skip `nvm use default` at startup (slow) and put the default Node on PATH directly
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" --no-use
[[ -r "$XDG_CONFIG_HOME/nvm/version" ]] && path=("$NVM_DIR/versions/node/v$(<"$XDG_CONFIG_HOME/nvm/version")/bin" $path)
