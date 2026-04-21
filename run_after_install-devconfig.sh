#!/bin/bash
# Install files staged by dev-config into their final locations.
# dev-config deploys work-specific files to ~/.local/share/devconfig/
# and this script copies them into place after chezmoi apply.
set -e

STAGING="$HOME/.local/share/devconfig"

# Exit if no staging directory exists (personal machine)
[ -d "$STAGING" ] || exit 0

# Snowdash: nvim plugin, sync script, cron setup
SNOWDASH="$STAGING/snowdash"
if [ -d "$SNOWDASH" ]; then
    # Sync script
    if [ -f "$SNOWDASH/snowdash-sync-snowtrail" ]; then
        mkdir -p "$HOME/.local/bin"
        cp "$SNOWDASH/snowdash-sync-snowtrail" "$HOME/.local/bin/snowdash-sync-snowtrail"
        chmod +x "$HOME/.local/bin/snowdash-sync-snowtrail"
    fi

    # Nvim plugin config (chezmoi template — render with chezmoi execute-template)
    if [ -f "$SNOWDASH/snowdash.lua.tmpl" ] && command -v chezmoi &>/dev/null; then
        mkdir -p "$HOME/.config/nvim/lua/plugins"
        chezmoi execute-template < "$SNOWDASH/snowdash.lua.tmpl" > "$HOME/.config/nvim/lua/plugins/snowdash.lua"
    fi

    # Cron setup
    if [ -f "$SNOWDASH/setup-snowdash-cron.sh" ]; then
        bash "$SNOWDASH/setup-snowdash-cron.sh"
    fi
fi
