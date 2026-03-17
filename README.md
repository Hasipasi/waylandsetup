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
├── waybar/.config/waybar/      → ~/.config/waybar/
├── hypr/.config/hypr/          → ~/.config/hypr/
├── rofi/.config/rofi/          → ~/.config/rofi/
├── kitty/.config/kitty/        → ~/.config/kitty/
└── wallpapers/wallpapers/      → ~/wallpapers/
```

Editing files in `~/.config/` edits the dotfiles directly (they are symlinks).

## Display configuration

| File | Purpose |
|------|---------|
| `~/.config/hypr/monitors.default.conf` | Tracked default (auto-detect all monitors) |
| `~/.config/hypr/monitors.conf` | **Your machine-specific config** (gitignored) |

`install.sh` creates `monitors.conf` from the default if it doesn't exist.
Edit that file to configure your displays:

```bash
# Example: ~/.config/hypr/monitors.conf
monitor=eDP-1, 2560x1440@60, 0x2160, 1.25
monitor=DP-2, 3840x2160@59.99700, 0x0, 1.5
```

See the [Hyprland monitor docs](https://wiki.hypr.land/Configuring/Monitors/) for syntax.
