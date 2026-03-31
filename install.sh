#!/bin/bash
# Dotfiles installer
# Usage: curl -fsSL https://raw.githubusercontent.com/shankur/dots/main/install.sh | bash

set -e

# Install chezmoi if not present
if ! command -v chezmoi &> /dev/null; then
    echo "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)"
    export PATH="$HOME/bin:$PATH"
fi

# Initialize and apply — chezmoi will prompt for profile, name, email, etc.
chezmoi init --apply https://github.com/shankur/dots.git

echo ""
echo "Dotfiles installed successfully!"
echo "Restart your shell: exec zsh"
