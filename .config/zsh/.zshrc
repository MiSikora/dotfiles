#!/usr/bin/env bash

# --- p10k ---

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZDOTDIR/fzf.zsh"
source "$XDG_CONFIG_HOME/secret/env"

bindkey -s ^f "tmux_session\n"
bindkey -s ^h "tmux_session $HOME\n"

# Use correct git dir for dotfiles
git() {
  current_dir=$PWD
  if [[ "$current_dir" == "$HOME" || "$current_dir" == "$XDG_CONFIG_HOME"* ]]; then
    command git --git-dir="$DOTFILES_GIT" --work-tree="$HOME" "$@"
  else
    command git "$@"
  fi
}

# Setup default Java versions
source <(jdk 21 graal)
source <(jdk 21)

# Make JDK shell function to set env variables
jdk() {
  source <(command jdk "$@")
  java -version
}

# Treat slashes as word separators for navigation
WORDCHARS=${WORDCHARS//[\/]}

# Use installed programs before system ones
export PATH="$HOMEBREW_PREFIX/opt/curl/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/sqlite/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/bash/bin:$PATH"

# Enable mouse scroll in git-delta
export LESS='-R --mouse'

alias bdump="brew bundle --global --force --describe dump"
alias bsync="brew update; brew upgrade; brew cu --all --cleanup --yes; brew bundle --verbose --global --force cleanup"

alias ls="lsd -A --group-directories-first"
alias fzfa="atuin history list --cmd-only | fzf"
