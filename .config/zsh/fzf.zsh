#!/usr/bin/env zsh

# Fzf init
source <(fzf --zsh)
source "$XDG_CONFIG_HOME/fzf/fzf-git/fzf-git.sh"

# Fzf-git without tmux popups
_fzf_git_fzf() {
  fzf --height 50% \
    --layout reverse --multi --min-height 20+ --border \
    --no-separator --header-border horizontal \
    --border-label-pos 2 \
    --color 'label:blue' \
    --preview-window 'right,50%' --preview-border line \
    --bind 'ctrl-/:change-preview-window(down,50%|hidden|)' "$@"
}

# Dotfiles repo detection
_fzf_git_use_dotfiles_repo() {
  [[ $PWD == $HOME || $PWD == $XDG_CONFIG_HOME(|/*) ]]
}

# Dotfiles-aware fzf-git widgets
_fzf_git_wrap_widget() {
  local widget=$1
  local original="__wrapped_${widget//-/_}"

  functions -c "$widget" "$original"

  eval "
    $widget() {
      local -x GIT_DIR GIT_WORK_TREE

      if _fzf_git_use_dotfiles_repo; then
        GIT_DIR=\$DOTFILES_GIT
        GIT_WORK_TREE=\$HOME
      fi

      $original
    }
  "

  zle -N "$widget"
}

# Dotfiles-aware widget registration
for widget in \
  fzf-git-files-widget \
  fzf-git-branches-widget \
  fzf-git-tags-widget \
  fzf-git-remotes-widget \
  fzf-git-hashes-widget \
  fzf-git-stashes-widget \
  fzf-git-lreflogs-widget \
  fzf-git-each_ref-widget \
  fzf-git-worktrees-widget
do
  _fzf_git_wrap_widget "$widget"
done

# Atuin history
bindkey -M emacs '^R' atuin-search

# Preview command
file_or_dir_preview="
  if [[ -d {} ]]; then
    lsd --tree --color=always {} | head -200
  else
    bat -n --color=always --line-range :500 {}
  fi
"

# Path completion
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude ".git" . "$1"
}

# Completion previews
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

# Fzf defaults
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
