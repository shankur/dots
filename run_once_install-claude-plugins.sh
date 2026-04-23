#!/bin/bash
# Install Claude Code plugins
set -e

if ! command -v claude &> /dev/null; then
    echo "  ⏭ claude not installed, skipping plugin setup"
    exit 0
fi

PLUGINS=(
    "superpowers@claude-plugins-official"
)

for plugin in "${PLUGINS[@]}"; do
    echo "  → Installing Claude plugin: $plugin"
    claude plugin install "$plugin" 2>/dev/null || true
done
