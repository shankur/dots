#!/bin/bash
# Install Zellij plugins
# plugins-version: zjstatus-latest harpoon-latest room-latest zellij-forgot-latest

set -e

PLUGINS_DIR="$HOME/.config/zellij/plugins"
mkdir -p "$PLUGINS_DIR"

echo "Installing Zellij plugins..."

curl -fsSL -o "$PLUGINS_DIR/zjstatus.wasm"      "https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm"
curl -fsSL -o "$PLUGINS_DIR/harpoon.wasm"       "https://github.com/Nacho114/harpoon/releases/latest/download/harpoon.wasm"
curl -fsSL -o "$PLUGINS_DIR/room.wasm"          "https://github.com/rvcas/room/releases/latest/download/room.wasm"
curl -fsSL -o "$PLUGINS_DIR/zellij-forgot.wasm" "https://github.com/karimould/zellij-forgot/releases/latest/download/zellij_forgot.wasm"

echo "Zellij plugins installed successfully"
