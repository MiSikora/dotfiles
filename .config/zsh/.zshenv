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

# Source the cached output of a slow init command instead of running it every time
# (bsync clears the cache)
evalcache() {
  local dir="$XDG_CACHE_HOME/zsh/evalcache"
  local name="${(j:_:)@}"
  local file="$dir/${name//[^A-Za-z0-9_.-]/_}.zsh"

  if [[ ! -s "$file" ]]; then
    [[ -d "$dir" ]] || mkdir -p "$dir"
    "$@" >"$file" || { rm -f "$file"; return 1 }
  fi

  source "$file"
}

evalcache_clear() {
  local dir="$XDG_CACHE_HOME/zsh/evalcache"
  [[ -d "$dir" ]] && rm -r -- "$dir"
  return 0
}
