#!/bin/bash
# Check if Claude CLI is installed

set -e

echo "🤖 Checking Claude CLI..."

# Check if claude command is available
if command -v claude &> /dev/null; then
    echo "✅ Claude CLI is already installed"
    exit 0
else
    echo "❌ Claude CLI not found. Please install Claude CLI from https://claude.com/download"
    exit 1
fi
