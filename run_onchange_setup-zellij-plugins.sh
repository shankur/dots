#!/bin/bash
# Install Zellij plugins
# plugins-version: zjstatus-latest harpoon-latest room-latest zellij-forgot-latest

set -e

PLUGINS_DIR="$HOME/.config/zellij/plugins"
mkdir -p "$PLUGINS_DIR"

echo "Installing Zellij plugins..."

declare -A PLUGINS=(
    ["zjstatus.wasm"]="https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm"
    ["harpoon.wasm"]="https://github.com/Nacho114/harpoon/releases/latest/download/harpoon.wasm"
    ["room.wasm"]="https://github.com/rvcas/room/releases/latest/download/room.wasm"
    ["zellij-forgot.wasm"]="https://github.com/karimould/zellij-forgot/releases/latest/download/zellij_forgot.wasm"
)

for plugin in "${!PLUGINS[@]}"; do
    echo "  Downloading $plugin..."
    curl -fsSL -o "$PLUGINS_DIR/$plugin" "${PLUGINS[$plugin]}"
done

echo "Zellij plugins installed successfully"
