#!/bin/bash
# Install Claude CLI if not present

set -e

echo "🤖 Checking Claude CLI..."

# Check if claude command is available
if command -v claude &> /dev/null; then
    echo "✅ Claude CLI is already installed ($(claude --version 2>/dev/null || echo 'version unknown'))"
    exit 0
fi

echo "📥 Installing Claude CLI..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - use official installer
    curl -fsSL https://storage.googleapis.com/osprey-cli-releases/install.sh | sh
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux - use official installer
    curl -fsSL https://storage.googleapis.com/osprey-cli-releases/install.sh | sh
else
    echo "❌ Unsupported OS. Please install Claude CLI from https://claude.com/download"
    exit 1
fi

echo "✅ Claude CLI installed successfully"
