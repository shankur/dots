#!/bin/bash
# Install Catppuccin themes for bat
# themes-hash: catppuccin-bat-v0.3.0

set -e

THEMES_DIR="$HOME/.config/bat/themes"
mkdir -p "$THEMES_DIR"

echo "Installing Catppuccin themes for bat..."

BASE_URL="https://raw.githubusercontent.com/catppuccin/bat/main/themes"

for variant in "Latte" "Frappe" "Macchiato" "Mocha"; do
    DEST="$THEMES_DIR/Catppuccin ${variant}.tmTheme"
    if [ ! -f "$DEST" ]; then
        echo "  Downloading Catppuccin $variant..."
        curl -fsSL -o "$DEST" "${BASE_URL}/Catppuccin%20${variant}.tmTheme"
    else
        echo "  Catppuccin $variant already installed"
    fi
done

echo "Rebuilding bat cache..."
bat cache --build

echo "Catppuccin themes for bat installed successfully"
