#!/bin/bash
# Sheldon Plugin Management Helper
# Usage: ./manage-plugins.sh [command] [options]

PLUGINS_FILE="$HOME/.config/sheldon/PLUGINS.md"
CONFIG_FILE="$HOME/.config/sheldon/plugins.toml"

case "$1" in
    "add")
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Usage: $0 add PLUGIN_NAME GITHUB_USER/REPO"
            exit 1
        fi

        echo "Adding plugin: $2 from $3"
        sheldon add "$2" --github="$3" --proto=https

        # Update tracking file
        DATE=$(date +%Y-%m-%d)
        echo "| $2 | $3 | Plugin description | ✅ Active | $DATE |" >> "$PLUGINS_FILE"
        echo "Added $2 to plugin list and tracking file"
        ;;

    "remove")
        if [ -z "$2" ]; then
            echo "Usage: $0 remove PLUGIN_NAME"
            exit 1
        fi

        echo "Removing plugin: $2"
        sheldon remove "$2"

        # Update tracking file (mark as removed)
        sed -i.bak "s/| $2 | .* | ✅ Active |/| $2 | ... | ❌ Removed |/" "$PLUGINS_FILE"
        echo "Removed $2 from plugin list"
        ;;

    "list")
        echo "Installed plugins:"
        sheldon list
        ;;

    "update")
        echo "Updating all plugins..."
        sheldon lock --update
        echo "All plugins updated!"
        ;;

    "status")
        echo "Plugin status:"
        cat "$PLUGINS_FILE"
        ;;

    *)
        echo "Sheldon Plugin Manager Helper"
        echo ""
        echo "Usage: $0 [command] [options]"
        echo ""
        echo "Commands:"
        echo "  add PLUGIN_NAME USER/REPO  - Add a new plugin"
        echo "  remove PLUGIN_NAME         - Remove a plugin"
        echo "  list                       - List all plugins"
        echo "  update                     - Update all plugins"
        echo "  status                     - Show plugin tracking status"
        echo ""
        echo "Examples:"
        echo "  $0 add git-aliases 'oh-my-zsh/oh-my-zsh' --dir=plugins/git"
        echo "  $0 remove git-aliases"
        echo "  $0 list"
        echo "  $0 update"
        ;;
esac