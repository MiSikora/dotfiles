#!/usr/bin/env zsh

export HOMEBREW_BUNDLE_FILE_GLOBAL="$XDG_CONFIG_HOME/brewfile"
export HOMEBREW_CASK_OPTS="--appdir=/Applications --no_quarantine: true"
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/config"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export DOTFILES_GIT="$HOME/projects/dotfiles.git"
export ANDROID_HOME="$HOME/Library/Android/sdk"

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(atuin init zsh)"
eval "$(rbenv init - --no-rehash zsh)"
