#!/bin/bash
# Install Claude CLI version 2.1.68

set -e

CLAUDE_VERSION="2.1.68"
CLAUDE_VERSION_PATH="$HOME/.local/share/claude/versions/$CLAUDE_VERSION"

echo "🤖 Checking Claude CLI version $CLAUDE_VERSION..."

# Check if the specific version is already installed
if [ -f "$CLAUDE_VERSION_PATH" ]; then
    echo "✅ Claude CLI $CLAUDE_VERSION is already installed"
    exit 0
else
    echo "📦 Installing Claude CLI $CLAUDE_VERSION..."

    # Check if claude command is available
    if ! command -v claude &> /dev/null; then
        echo "❌ Claude CLI not found. Please install Claude CLI first from https://claude.com/download"
        exit 1
    fi

    # Install the specific version with autoupdater disabled
    DISABLE_AUTOUPDATER=1 claude install --force "$CLAUDE_VERSION"

    echo "✅ Claude CLI $CLAUDE_VERSION installed successfully"
fi
