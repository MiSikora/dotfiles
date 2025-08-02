#!/usr/bin/env zsh

# XDG base dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_DATA_HOME="$XDG_LOCAL_HOME/share"
export XDG_STATE_HOME="$XDG_LOCAL_HOME/state"

# zsh dir
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export PATH="$XDG_LOCAL_HOME/bin:$PATH"
