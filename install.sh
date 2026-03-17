#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
STOW_PACKAGES=(waybar hypr rofi kitty)

echo "==> Dotfiles installer"
echo "    Dotfiles: $DOTFILES_DIR"
echo "    Backup:   $BACKUP_DIR"
echo ""

# Check dependencies
if ! command -v stow &>/dev/null; then
    echo "ERROR: stow is not installed. Run: pacman -S stow"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

# --- Backup and stow user packages ---
for pkg in "${STOW_PACKAGES[@]}"; do
    echo "--> [$pkg]"

    # Find all target paths this package would create
    while IFS= read -r -d '' src; do
        # Compute relative path from package root
        rel="${src#$DOTFILES_DIR/$pkg/}"
        target="$HOME/$rel"

        # If target exists and is not already our symlink, back it up
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            backup_dest="$BACKUP_DIR/$pkg/$rel"
            mkdir -p "$(dirname "$backup_dest")"
            mv "$target" "$backup_dest"
            echo "    backed up: $target"
        elif [ -L "$target" ]; then
            # Remove stale or existing symlink so stow can replace it
            rm "$target"
        fi
    done < <(find "$DOTFILES_DIR/$pkg" -not -type d -print0)

    stow --dir="$DOTFILES_DIR" --target="$HOME" "$pkg"
    echo "    stowed: $pkg"
done

# Make waybar scripts executable
chmod +x "$HOME/.config/waybar/scripts/"*.sh 2>/dev/null || true

# --- keyd (system-level, needs sudo) ---
echo "--> [keyd]"
if [ -f /etc/keyd/trackpoint.conf ] && [ ! -L /etc/keyd/trackpoint.conf ]; then
    sudo mkdir -p "$BACKUP_DIR/keyd/etc/keyd"
    sudo mv /etc/keyd/trackpoint.conf "$BACKUP_DIR/keyd/etc/keyd/trackpoint.conf"
    echo "    backed up: /etc/keyd/trackpoint.conf"
fi
sudo mkdir -p /etc/keyd
sudo cp "$DOTFILES_DIR/keyd/etc/keyd/trackpoint.conf" /etc/keyd/trackpoint.conf
echo "    installed: /etc/keyd/trackpoint.conf"
sudo systemctl enable --now keyd 2>/dev/null || true
sudo keyd reload 2>/dev/null || true

echo ""
echo "==> Done. Backup saved to: $BACKUP_DIR"
echo "    To restore, run: ./restore.sh $BACKUP_DIR"
