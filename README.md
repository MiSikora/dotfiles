## Initial configuration

Have the git-crypt key ready as `~/dotfiles.pgp`, then:

```
curl -sL https://github.com/MiSikora/dotfiles/archive/HEAD.tar.gz | tar xz -C ~ --strip-component=1
bash ~/.config/setup/setup.sh
```

The script asks for the profile (`home` or `work`), installs the Xcode Command Line Tools and
Homebrew, runs the Brewfile for the profile, clones the dotfiles as a bare repository, imports the
GPG keys and decrypts `~/.config/secret`, installs `gh-stack`, `fzf-git` and `tpm`, pins Ruby,
Python, Node and Rust, and makes Homebrew's zsh the login shell. Open a new terminal afterwards.

Neovim installs its plugins and tree-sitter parsers on first start.

## macOS config

Give the terminal Full Disk Access in **System Settings > Privacy & Security** and run:

```
bash ~/.config/setup/macos.sh
```

Some settings need a logout or restart to apply.

## Permissions

Grant these in **System Settings > Privacy & Security** when the apps ask:

- AeroSpace: Accessibility
- Karabiner-Elements: Input Monitoring (and approve the driver extension)
- Espanso: Accessibility
- Shottr: Screen Recording
- Raycast: Accessibility, Files and Folders

## Raycast

1. Open Raycast and enable launch at login.
2. Import the configuration from `~/.config/raycast/config.rayconfig`.
3. Go to **System Settings > Keyboard** and set the Globe key to do nothing.
4. Go to **System Settings > Keyboard > Keyboard Shortcuts > Spotlight** and disable the shortcut.
5. Hold ⌘ and drag the Spotlight icon out of the menu bar.

## Apps to configure

### Common

- 1Password
- Calendar
- DuckDuckGo
- Firefox
- JetBrains Toolbox
- Mac Media Key Forwarder
- Mail
- Messages
- Shottr (Meta+P hotkey)
- Spotify

### Home

- Affinity
- Capture One
- Messenger
- Pocket Casts
- Slack
- WhatsApp

### Work

- Asana
- Bitwarden
- Claude
- Figma
- Mattermost
- Outlook
- Zoom
