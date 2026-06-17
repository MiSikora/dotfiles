#!/usr/bin/env zsh

# XDG dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_DATA_HOME="$XDG_LOCAL_HOME/share"
export XDG_STATE_HOME="$XDG_LOCAL_HOME/state"

# User binaries
typeset -U path PATH
path=("$XDG_LOCAL_HOME/bin" $path)

# Editors
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim +Man!"

# Shell sessions
export SHELL_SESSIONS_DISABLE=1
