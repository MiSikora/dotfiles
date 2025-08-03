#!/usr/bin/env zsh

# Initialize fzf 
source <(fzf --zsh)
source "$XDG_CONFIG_HOME/fzf/fzf-git/fzf-git.sh"

# Rebind ctrl+r to use Atuin instead of fzf 
bindkey -M emacs '^R' atuin-search

file_or_dir_preview="
  if [[ -d {} ]]; then
    lsd --tree --color=always {} | head -200
  else
    bat -n --color=always --line-range :500 {}
  fi
"

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude ".git" . "$1"
}

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

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview '$file_or_dir_preview'"

export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_ALT_C_OPTS="--preview 'lsd --tree --color=always {} | head -200'"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"
