#!/usr/bin/env zsh

# --- p10k ---

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f "$ZDOTDIR/.p10k.zsh" ]] || source "$ZDOTDIR/.p10k.zsh"

# Keep zsh line editing in emacs mode even though EDITOR is nvim.
bindkey -e

# Interactive plugins
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZDOTDIR/fzf.zsh"

# Allow Ctrl-S for fzf-git stashes
[[ -t 0 ]] && stty -ixon

# Atuin history widgets
eval "$(atuin init zsh)"

# Word navigation
WORDCHARS=${WORDCHARS//[\/]}

# Git delta
export LESS='-R'

# Shell keybindings
bindkey -s ^f "tmux_session pick\n"
bindkey -s ^h "tmux_session switch $HOME\n"
bindkey -s ^n "tmux_session switch $XDG_CONFIG_HOME\n"

# Dotfiles git
git() {
  local current_dir=$PWD

  if [[ "$current_dir" == "$HOME" || "$current_dir" == "$XDG_CONFIG_HOME"* ]]; then
    command git --git-dir="$DOTFILES_GIT" --work-tree="$HOME" "$@"
  else
    command git "$@"
  fi
}

# JDK helper
jdk() {
  source <(command jdk "$@")
  java -version
}

airlock() {
  osascript -e 'tell application "AeroSpace" to quit' >/dev/null 2>&1 || true
  pkill -x AeroSpace >/dev/null 2>&1 || true
  open -a AeroSpace
}

_dotfiles_profile() {
  local profile="${1:-${DOTFILES_PROFILE:-}}"

  if [[ -z "$profile" && -r "$XDG_CONFIG_HOME/profile" ]]; then
    profile="$(<"$XDG_CONFIG_HOME/profile")"
  fi

  case "$profile" in
  home|work)
    export DOTFILES_PROFILE="$profile"
    export HOMEBREW_DOTFILES_PROFILE="$profile"
    export HOMEBREW_BUNDLE_FILE_GLOBAL="$XDG_CONFIG_HOME/homebrew/brewfile"
    ;;
  "")
    print -u2 "DOTFILES_PROFILE is not set. Expected 'home' or 'work'."
    return 1
    ;;
  *)
    print -u2 "Invalid DOTFILES_PROFILE=$profile. Expected 'home' or 'work'."
    return 1
    ;;
  esac
}

bdump() {
  if ! _dotfiles_profile "$1"; then
    return 1
  fi

  "$XDG_CONFIG_HOME/homebrew/brewfile-dump"
}

bsync() {
  if ! _dotfiles_profile "$1"; then
    return 1
  fi

  brew update &&
    brew upgrade &&
    brew cu --all --cleanup --yes &&
    brew bundle --verbose --global --force cleanup
}

alias ls="lsd -A --group-directories-first -I .DS_Store -I dotfiles.git"
alias fzfa="atuin history list --cmd-only | fzf"
