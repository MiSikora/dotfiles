#!/usr/bin/env zsh
set -e

section() {
  echo ""
  printf "%b" "\033[1;33m\0$1\033[0m\n"
}

info() {
  printf "%b" "\033[1;37m\0$1\033[0m\n"
}

success() {
  printf "%b" "\033[1;32m\0$1\033[0m\n"
}

fail() {
  echo ""
  printf "%b" "\033[1;31m\0$1\033[0m\n"
  echo ""
  exit 1
}

section "Xcode CLI tools setup"

if ! xcode-select --print-path > /dev/null 2>&1; then
  info "Installing Xcode CLI tools"
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  softwareupdate -i -a
  if ! [[ -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress ]]; then
    info "Deleting Xcode CLI tools progress temp file"
    rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  fi

  if ! xcode-select --print-path > /dev/null 2>&1; then
    fail "Xcode CLI tools not found"
  else
    success "Xcode CLI tools installed"
  fi
else
  success "Xcode CLI tools already installed"
fi

section "Homebrew setup"

if ! command -v brew > /dev/null 2>&1; then
  info "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    info "Configuring Homebrew in PATH for this session"
    export PATH="/opt/homebrew/bin:$PATH"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"

  if ! command -v brew > /dev/null 2>&1; then
    fail "Homebrew not found"
  else
    info "Disabling Homebrew analytics"
    brew analytics off
    success "Homebrew installed"
  fi
else
  success "Homebrew already installed"
fi

brew bundle --verbose --global

section "Dotfiles git repository setup"

if [[ ! -d "$DOTFILES_GIT" ]]; then
  info "Initializing dotfiles git repository"
  mkdir -p "$DOTFILES_GIT"
  command git init --bare "$DOTFILES_GIT"
  command git --git-dir="$DOTFILES_GIT" --work-tree="$HOME" add .
  command git --git-dir="$DOTFILES_GIT" --work-tree="$HOME" remote add origin https://github.com/MiSikora/dotfiles.git
  command git --git-dir="$DOTFILES_GIT" --work-tree="$HOME" remote update
  command git --git-dir="$DOTFILES_GIT" --work-tree="$HOME" checkout trunk
  success "Dotfiles git repository initialized"
else
  success "Dotfiles git repository already exists"
fi

section "GPG setup"

if [[ ! -d "$GNUPGHOME" ]]; then
  info "Creating GPG home directory"
  mkdir -m 700 "$GNUPGHOME"
  success "GPG home directory created"
else
  success "GPG already configured"
fi

if ! gpg --list-secret-keys --keyid-format=long | grep -q E210EE60F056F7DD; then
  info "The script will now import the git-crypt key"
  git_crypt_key_path="$HOME/dotfiles.pgp"
  if [[ ! -f "$git_crypt_key_path" ]]; then
    info "Please move the git-crypt key to $git_crypt_key_path and press any key to continue"
    read -s -r -n 1
  fi

  if [[ ! -f "$git_crypt_key_path" ]]; then
    fail "$git_crypt_key_path does not exist"
  fi
  
  gpg --import "$git_crypt_key_path"
  echo -e "trust\n5\ny\nsave\n" | gpg --command-fd 0 --edit-key "E210EE60F056F7DD"
  info "git-crypt key successfully imported"

  info "Do you wish to delete $git_crypt_key_path file? [Y/n] "
  read -r yn
  case $yn in
    [Nn]*)
      success "Keeping $git_crypt_key_path file"
      ;;
    *)
      rm -f "$git_crypt_key_path"
      success "$git_crypt_key_path file succsessfully deleted"
      ;;
  esac
else
  success "git-crypt key already exists"
fi

if [[ "$(head -n 1 "$XDG_CONFIG_HOME/secret/check.txt")" != "decrypted" ]]; then
  info "Decrypting secrets"
  command git --git-dir="$DOTFILES_GIT" --work-tree="$HOME" crypt unlock
  
  if [[ "$(head -n 1 "$XDG_CONFIG_HOME/secret/check.txt")" != "decrypted" ]]; then
    fail "Failed to decrypt secrets"
  else
    success "Secrets decrypted"
  fi
else
  success "Secrets already decrypted"
fi

if ! gpg --list-secret-keys --keyid-format=long | grep -q 533F4DBAF854E83C; then
  info "The script will now import the git signing key"
  git_signing_key_path="$XDG_CONFIG_HOME/secret/git.pgp"

  if [[ ! -f "$git_signing_key_path" ]]; then
    fail "$git_signing_key_path does not exist"
  fi
  
  gpg --import "$git_signing_key_path"
  echo -e "trust\n5\ny\nsave\n" | gpg --command-fd 0 --edit-key "533F4DBAF854E83C"  
  info "git signing key successfully imported"
else
  success "git signing key already exists"
fi

if [[ ! $(echo host=github.com | git credential-osxkeychain get) ]]; then
  info "Importing GitHub token"
  < "$XDG_CONFIG_HOME/secret/gh-token.txt" git credential-osxkeychain store

  if [[ ! $(echo host=github.com | git credential-osxkeychain get) ]]; then
    fail "Failed to import GitHub token"
  else
    success "GitHub token imported"
  fi
else
  success "GitHub token already imported"
fi

section "fzf-git setup"

fzf_git_dir="$XDG_CONFIG_HOME/fzf/fzf-git"
if [[ ! -d "$fzf_git_dir" ]]; then
  info "Installing fzf-git"
  git clone https://github.com/junegunn/fzf-git.sh.git "$fzf_git_dir"

  if [[ ! -d "$fzf_git_dir" ]]; then
    fail "Failed to install fzf-git"
  else
    success "fzf-git installed"
  fi
else
  success "fzf-git already installed"
fi

section "tmux setup"

tpm_dir="$XDG_CONFIG_HOME/tmux/plugins/tpm"
if [[ ! -d "$tpm_dir" ]]; then
  info "Installing tpm"
  git clone https://github.com/tmux-plugins/tpm "$tpm_dir"

  if [[ ! -d "$tpm_dir" ]]; then
    fail "Failed to install tpm"
  fi

  info "Installing tpm plugins"
  source "$XDG_CONFIG_HOME/tmux/plugins/tpm/bin/install_plugins"
  success "tpm installed"
else
  success "tpm already installed"
fi

section "rbenv setup"

ruby_version="$(cat "$XDG_CONFIG_HOME"/rbenv/version)"
if [[ $(rbenv version-name global) != "$ruby_version" ]]; then
  info "Installing Ruby $ruby_version"
  rbenv install "$ruby_version"
  rbenv global "$ruby_version"
  rbenv rehash

  if [[ $(rbenv version-name global) != "$ruby_version" ]]; then
    fail "Failed to install Ruby $ruby_version"
  else
    success "Installed Ruby $ruby_version"
  fi
else
  success "Ruby $ruby_version already installed"
fi

section "pynev setup"

python_version="$(cat "$XDG_CONFIG_HOME"/pyenv/version)"
if [[ $(pyenv version-name global) != "$python_version" ]]; then
  info "Installing Python $python_version"
  pyenv install "$python_version"
  pyenv global "$python_version"
  pyenv rehash

  if [[ $(pyenv version-name global) != "$python_version" ]]; then
    fail "Failed to install Python $python_version"
  else
    success "Installed Python $python_version"
  fi
else
  success "Python $python_version already installed"
fi

section "zsh setup"

brew_zsh="$(brew --prefix)/bin/zsh"
if [[ "$SHELL" != "$brew_zsh" ]]; then
  info "Changing the default shell to Homebrew's zsh"
  if ! grep -Fxq "$brew_zsh" /etc/shells; then
    info "Adding Homebrew's zsh to allowed shells"
    echo "$brew_zsh" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s "$brew_zsh"

  success "Homebrew's zsh changed to the default shell"
else
  success "Homebrew's zsh is already the default shell"
fi

echo ""
success "Dotfiles setup finished"
echo ""
