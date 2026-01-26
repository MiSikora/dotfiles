## Initial configuration

```
curl -sL https://github.com/MiSikora/dotfiles/archive/HEAD.tar.gz | tar xz -C ~ --strip-component=1
source .zshenv && source "$ZDOTDIR/.zprofile"
chmod +x ~/.config/setup/setup.sh && sh ~/.config/setup/setup.sh
```

## macOS config

Give the new terminal emulator Full Disk Access from the System Settings and run:

```
sh ~/.config/setup/macos.sh
```

## Raycast

1. Open Raycast.
2. Enable option to open it at login.
3. Enable option to use emoji picker.
4. Grant access to Files and Folders.
5. Go to Raycast settings.
6. Import configuration from `~/.config/raycast/config.rayconfig`.
7. Go to **System Preferences > Keyboard**.
8. Disable Emoji picker on Globe key.
9. Go to **System Preferences > Keyboard > Shortcuts > Spotlight**.
10. Disable Spotlight's keyboard shortcut.
11. Drag and drop (⌘) Spotlight's menu bar icon to remove it.

## Apps to configure

- Karabiner-Elements
- 1Password
- Mullvad
- Shottr (Meta+P hotkey)
- Firefox
- Espanso
- JetBrains Toolbox
- Capture One
- Affinity
- Email
- Calendar
- Messages
- WhatsApp
- Messenger
- Slack
- Spotify
- Pocket Casts
- Mac Media Key Forwarder
