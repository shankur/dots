#!/bin/bash
# Dotfiles installer with profile support
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/shankur/dots/main/install.sh | bash -s -- --profile work
#   curl -fsSL https://raw.githubusercontent.com/shankur/dots/main/install.sh | bash -s -- --profile personal

set -e

PROFILE="personal"
NAME="Ankur Sharma"
EMAIL=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --profile)
            PROFILE="$2"
            shift 2
            ;;
        --name)
            NAME="$2"
            shift 2
            ;;
        --email)
            EMAIL="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--profile work|personal] [--name \"Your Name\"] [--email your@email.com]"
            exit 1
            ;;
    esac
done

# Set email based on profile if not provided
if [[ -z "$EMAIL" ]]; then
    case $PROFILE in
        work)
            EMAIL="ankur.sharma@snowflake.com"
            ;;
        personal)
            EMAIL="inbox.ankur@pm.me"
            ;;
        *)
            echo "Error: Invalid profile '$PROFILE'. Use 'work' or 'personal'"
            exit 1
            ;;
    esac
fi

echo "🚀 Installing dotfiles with profile: $PROFILE"
echo "   Name: $NAME"
echo "   Email: $EMAIL"
echo ""

# Install chezmoi if not present
if ! command -v chezmoi &> /dev/null; then
    echo "📦 Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)"
    # Add to PATH for this session
    export PATH="$HOME/bin:$PATH"
fi

# Create chezmoi config
echo "📝 Creating chezmoi configuration..."
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << EOF
[data]
    profile = "$PROFILE"
    name = "$NAME"
    email = "$EMAIL"
EOF

# Initialize and apply dotfiles
echo "⚙️  Initializing dotfiles..."
chezmoi init --apply https://github.com/shankur/dots.git

echo ""
echo "✅ Dotfiles installed successfully!"
echo "🔄 Restart your shell: exec zsh"
