#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_PACKAGES=(waybar hypr rofi kitty)

if [ -z "$1" ]; then
    echo "Usage: ./restore.sh <backup-dir>"
    echo ""
    echo "Available backups:"
    ls "$HOME/.dotfiles-backup/" 2>/dev/null || echo "  (none)"
    exit 1
fi

BACKUP_DIR="$1"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "ERROR: Backup directory not found: $BACKUP_DIR"
    exit 1
fi

echo "==> Restoring from: $BACKUP_DIR"
echo ""

# --- Unstow user packages ---
for pkg in "${STOW_PACKAGES[@]}"; do
    echo "--> [$pkg] unstowing"
    stow --dir="$DOTFILES_DIR" --target="$HOME" --delete "$pkg" 2>/dev/null || true
done

# --- Restore backed up files ---
for pkg in "${STOW_PACKAGES[@]}"; do
    pkg_backup="$BACKUP_DIR/$pkg"
    if [ ! -d "$pkg_backup" ]; then
        continue
    fi

    echo "--> [$pkg] restoring"
    while IFS= read -r -d '' src; do
        rel="${src#$pkg_backup/}"
        target="$HOME/$rel"
        mkdir -p "$(dirname "$target")"
        mv "$src" "$target"
        echo "    restored: $target"
    done < <(find "$pkg_backup" -not -type d -print0)
done

echo ""
echo "==> Restore complete."
