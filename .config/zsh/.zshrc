#!/usr/bin/env zsh

# --- p10k ---

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# --- zsh --

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- fzf ---

# fzf config based on: https://github.com/josean-dev/dev-environment-files/blob/cb670e8890ca9d8baf978b38ed75987b742032e6/.zshrc

source <(fzf --zsh)
# rebind fzf ctrl+r to atuin
bindkey -M emacs '^R' atuin-search

# Use fd for fzf file lookup
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d -hidden -strip-cwd-prefix -exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

file_or_dir_preview="if [[ -d {} ]]; then lsd --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'lsd --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of thecommand.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'lsd --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}" "$@" ;;
    ssh)          fzf --preview 'dig {}' "$@" ;;
    *)            fzf --preview "$file_or_dir_preview" "$@" ;;
  esac
}

source "$XDG_CONFIG_HOME/fzf/fzf-git/fzf-git.sh"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

# --- misc ---

# Treat slashes as word sperators for navigation
WORDCHARS=${WORDCHARS//[\/]}

# Use installed programs before system
export PATH="$(brew --prefix)/opt/curl/bin:$PATH"
export PATH="$(brew --prefix)/opt/sqlite/bin:$PATH"
export PATH="$(brew --prefix)/opt/bash/bin:$PATH"

# Enable mouse scroll in git-delta
export LESS='-R --mouse'

# Create tmux session from a dir
# Based on https://github.com/ThePrimeagen/.dotfiles/blob/602019e902634188ab06ea31251c01c1a43d1621/bin/.local/scripts/tmux-sessionizer
tmux_session() {
  if [[ $# -eq 1 ]]; then
    selected=$1
  else
    selected=$(fd -t d -d 1 -E '*.git' . "$HOME/projects" | fzf)
  fi

  if [[ -z $selected ]]; then
    return 0
  fi

  selected_name=$(basename "$selected" | tr . _)
  tmux_running=$(pgrep tmux)

  if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new -s $selected_name -c $selected
    return 0
  fi

  if ! tmux has -t=$selected_name 2> /dev/null; then
    tmux new -ds $selected_name -c $selected
  fi  

  if [[ -n $TMUX ]]; then
    tmux switchc -t $selected_name
  else
    tmux attach -d -t $selected_name -c $selected
  fi
}

bindkey -s ^f "tmux_session\n"

# Use correct git dir for dotfiles
git() {
  current_dir=$(echo $PWD)
  if [[ "$current_dir" == $(echo $HOME) ]] || [[ "$current_dir" == $(echo $XDG_CONFIG_HOME)* ]]; then
    command git --git-dir="$DOTFILES_GIT" --work-tree="$HOME" "$@"
  else
    command git "$@"
  fi
}

# Select JDK version
jdk() {
  version=$1
  export JAVA_HOME=$(/usr/libexec/java_home -v"$version")
  java -version
}

export PATH="$PATH:$XDG_LOCAL_HOME/bin"

alias bsync="brew update; brew upgrade; brew cu --all --cleanup --yes; brew bundle --verbose --global --force cleanup"
alias bdump="brew bundle --global --force --describe dump"

alias ls="lsd -A --permission octal --group-directories-first"
alias fzfa="atuin history list --cmd-only | fzf"

alias tsh="tmux_session ~"
