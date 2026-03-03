# Zsh Plugin Inventory

## Installation Info
- **Plugin Manager**: Sheldon v0.8.5
- **Installed via**: `cargo install sheldon`
- **Installation Date**: 2026-03-01
- **Config Location**: `~/.config/sheldon/plugins.toml`

## Current Plugins

### Prompt & Theme 🎨
| Plugin | Source | Description | Status | Added |
|--------|--------|-------------|---------|--------|
| Starship | starship/starship | Cross-shell prompt (Rust) | ✅ Active | 2026-03-01 |

### Core Plugins ⚡
| Plugin | Source | Description | Status | Added |
|--------|--------|-------------|---------|--------|
| zsh-autosuggestions | zsh-users/zsh-autosuggestions | Fish-like autosuggestions | ✅ Active | 2026-03-01 |
| zsh-syntax-highlighting | zsh-users/zsh-syntax-highlighting | Syntax highlighting | ✅ Active | 2026-03-01 |
| zsh-completions | zsh-users/zsh-completions | Additional completions | ✅ Active | 2026-03-01 |

### Productivity Tools 🛠️
| Tool/Plugin | Source | Description | Status | Added |
|--------|--------|-------------|---------|--------|
| zoxide (binary) | ajeetdsouza/zoxide | Smart directory jumping | ✅ Active | 2026-03-01 |
| git-extras (binary) | tj/git-extras | Extra git commands | ✅ Active | 2026-03-01 |
| fzf | junegunn/fzf | Fuzzy finder | ✅ Active | 2026-03-01 |
| fzf-tab | Aloxaf/fzf-tab | Fuzzy tab completion | ✅ Active | 2026-03-01 |
| zsh-abbr | olets/zsh-abbr | Fish-like abbreviations | ✅ Active | 2026-03-01 |
| history-substring-search | zsh-users/zsh-history-substring-search | Better history search | ✅ Active | 2026-03-01 |
| git-open | paulirish/git-open | Open repo in browser | ✅ Active | 2026-03-01 |
| you-should-use | MichaelAquilina/zsh-you-should-use | Alias reminders | ✅ Active | 2026-03-01 |

## Plugin Management Commands

```bash
# Install/update all plugins
sheldon lock

# Add a new plugin
sheldon add PLUGIN_NAME --github=USER/REPO

# Remove a plugin
sheldon remove PLUGIN_NAME

# Update plugins
sheldon lock --update

# List installed plugins
sheldon list

# Generate shell source (for debugging)
sheldon source
```

## Installation History

### 2026-03-01 - Initial Setup
- Installed Sheldon via cargo
- Added core plugin set:
  - ~~powerlevel10k~~ (removed by user request)
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - zsh-completions
  - fzf (fuzzy finder)

### 2026-03-01 - Productivity Enhancement
- Added 6 top productivity plugins:
  - zoxide (smart directory jumping)
  - fzf-tab (fuzzy tab completion)
  - zsh-abbr (abbreviations)
  - history-substring-search (better history)
  - git-open (open repos in browser)
  - you-should-use (alias reminders)

### 2026-03-01 - Starship Prompt
- Installed Starship v1.24.2 via cargo
- Added Starship initialization to zsh config
- Fast, cross-shell prompt with git integration

### 2026-03-01 - Zoxide Binary
- Installed zoxide v0.9.9 via cargo
- Added zoxide initialization to zsh config
- Removed zoxide plugin (using direct binary instead)

### 2026-03-01 - Git-Extras
- Installed git-extras v7.4.0 via Homebrew
- Added git-extras completions to zsh config
- Provides 60+ additional git commands

### 2026-03-01 - Split-Screen Terminal Setup
- Configured tmux with Catppuccin Mocha theme
- Created split-prompt scripts for 2-pane layout
- Added aliases: split, sp, asplit, as
- Top pane: Command output | Bottom pane: Prompt

### 2026-03-03 - Neovim Configuration
- Installed AstroNvim v4.0+ distribution
- Configured Catppuccin Mocha theme (matches terminal)
- Added language support: TypeScript, Python, Rust, Go
- Enabled GitHub Copilot integration
- Full LSP and completion setup

---
*This file tracks all plugins and changes for easy management and documentation.*