#!/bin/bash
# Add a curated "Projects" stack to the macOS Dock (pointing at the generated
# VSCode workspaces in ~/Projects/_workspaces/) and make .code-workspace files
# open in VS Code. Idempotent, macOS-only. Manual — not wired into
# `chezmoi apply`; re-run any time you want to (re)install the stack.
set -euo pipefail

if [[ "$(uname)" != "Darwin" ]]; then
    echo "setup-projects-dock: macOS only, nothing to do here." >&2
    exit 1
fi

WS_DIR="$HOME/Projects/_workspaces"
GEN="$HOME/.local/bin/gen-projects-workspace"
LSREG=/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister

mkdir -p "$WS_DIR"

# Populate / refresh the workspace files (best-effort; the stack still works
# even if this fails — it would just be empty until the next generation).
if [ -x "$GEN" ]; then
    "$GEN" >/dev/null 2>&1 || echo "WARNING: gen-projects-workspace failed; Dock stack may be empty" >&2
fi

# Add the stack to the Dock if it isn't already there (idempotent).
if defaults read com.apple.dock persistent-others 2>/dev/null | grep -q "Projects/_workspaces"; then
    echo "'Projects' Dock stack already present; leaving it."
else
    defaults write com.apple.dock persistent-others -array-add "<dict>
        <key>tile-data</key><dict>
            <key>file-data</key><dict>
                <key>_CFURLString</key><string>file://$HOME/Projects/_workspaces/</string>
                <key>_CFURLStringType</key><integer>15</integer>
            </dict>
            <key>file-label</key><string>Projects</string>
            <key>file-type</key><integer>2</integer>
            <key>displayas</key><integer>1</integer>
            <key>showas</key><integer>3</integer>
            <key>arrangement</key><integer>1</integer>
        </dict>
        <key>tile-type</key><string>directory-tile</string>
    </dict>"
    killall Dock
    echo "Added 'Projects' stack to the Dock (list view, sorted by name)."
fi

# Give the stack the VS Code logo instead of a generic folder (best-effort:
# needs `swift` + the VS Code app). The folder's custom-icon resource file
# (`Icon\r`) is the marker, so this only runs once.
if [ ! -f "$WS_DIR/$(printf 'Icon\r')" ] \
   && [ -f "/Applications/Visual Studio Code.app/Contents/Resources/Code.icns" ] \
   && command -v swift >/dev/null 2>&1; then
    if swift - >/dev/null 2>&1 <<'SWIFT'
import AppKit
let iconPath = "/Applications/Visual Studio Code.app/Contents/Resources/Code.icns"
let target = NSString(string: "~/Projects/_workspaces").expandingTildeInPath
guard let img = NSImage(contentsOfFile: iconPath) else { exit(1) }
exit(NSWorkspace.shared.setIcon(img, forFile: target, options: []) ? 0 : 1)
SWIFT
    then
        killall Dock 2>/dev/null || true
        echo "Set the VS Code icon on the Projects stack."
    else
        echo "WARNING: could not set the Projects stack icon" >&2
    fi
fi

# Make .code-workspace files open in VS Code (not Cursor or another fork). Uses
# an extension-based LaunchServices handler — what Finder's "Open With → Change
# All" writes — because .code-workspace has only a dynamic UTI, which duti and
# the LSSetDefaultRoleHandler API reject (-50). Idempotent.
if [ -d "/Applications/Visual Studio Code.app" ]; then
    if defaults read com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers 2>/dev/null \
         | grep -A2 'code-workspace' | grep -q 'com.microsoft.VSCode'; then
        echo ".code-workspace already opens in VS Code."
    else
        defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add \
            '{LSHandlerContentTag="code-workspace";LSHandlerContentTagClass="public.filename-extension";LSHandlerRoleAll="com.microsoft.VSCode";}'
        "$LSREG" -r -domain local -domain system -domain user >/dev/null 2>&1 || true
        killall lsd 2>/dev/null || true   # reload LaunchServices (the old `lsregister -kill` is gone)
        echo "Set .code-workspace to open in VS Code."
    fi
fi
