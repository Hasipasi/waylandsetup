# dotfiles

Hyprland setup for ThinkPad X1 Carbon 6th (Arch Linux).

## Includes

| Package | Config |
|---------|--------|
| hyprland | compositor, keybindings |
| waybar | status bar with CPU/power/temp/battery/volume/brightness |
| rofi | application launcher |
| kitty | terminal |

## Install

```bash
# 1. Install required packages
pacman -S --needed - < packages.txt

# 2. Install dotfiles (backs up existing configs, creates symlinks)
./install.sh
```

## Restore

```bash
# List available backups
./restore.sh

# Restore a specific backup
./restore.sh ~/.dotfiles-backup/20240101_120000
```

## How it works

Uses [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks.
Each app is a stow package mirroring the target filesystem layout:

```
dotfiles/
├── waybar/.config/waybar/   → ~/.config/waybar/
├── hypr/.config/hypr/       → ~/.config/hypr/
├── rofi/.config/rofi/       → ~/.config/rofi/
├── kitty/.config/kitty/     → ~/.config/kitty/
└── keyd/etc/keyd/           → /etc/keyd/  (copied, not symlinked)
```

Editing files in `~/.config/` edits the dotfiles directly (they are symlinks).
