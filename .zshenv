#!/usr/bin/env zsh

# XDG base dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_DATA_HOME="$XDG_LOCAL_HOME/share"
export XDG_STATE_HOME="$XDG_LOCAL_HOME/state"

# Include custom scripts in the path
export PATH="$XDG_LOCAL_HOME/bin:$PATH"

# Zsh configuration
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Disable Apple's save/resotre mechanism
export SHELL_SESSIONS_DISABLE=1

# Configure Neovim as editor
export MANPAGER="nvim +Man!"
