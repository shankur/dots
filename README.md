# My Dotfiles - Managed with chezmoi

This repository contains my dotfiles and development environment setup, managed with [chezmoi](https://www.chezmoi.io/).

## 🛠️ What's Included

- **Zsh Configuration** - with zplug plugin manager
- **Tmux Configuration** - with Catppuccin Mocha theme
- **Neovim Configuration** - AstroNvim with custom Claude integration
- **Claude Integration** - Remote control scripts for Neovim
- **Terminal Configuration** - Ghostty terminal setup
- **Starship Prompt** - with Catppuccin Mocha theme

## 🚀 Quick Setup on New Machine

### Option 1: Full Setup
```bash
# Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/YOUR_USERNAME/dotfiles.git
```

### Option 2: Step by Step
```bash
# Install chezmoi
brew install chezmoi  # macOS
# or
curl -sfL https://git.io/chezmoi | sh  # Linux

# Initialize with your dotfiles
chezmoi init https://github.com/YOUR_USERNAME/dotfiles.git

# Preview changes
chezmoi diff

# Apply configurations
chezmoi apply
```

## 📦 Dependencies

The setup script will automatically install:

### Core Tools
- Git, Neovim, Tmux
- Go, Rust, Node.js, Python3
- fzf, git-extras, starship, zoxide

### Plugin Managers
- zplug (zsh plugins)
- Lazy.nvim (Neovim plugins - via AstroNvim)

### Manual Setup Required
- **Claude CLI** - Install and authenticate manually
- **Git Configuration** - Set your credentials

## 🎯 Key Features

### Zsh Setup
- Starship prompt with Catppuccin Mocha
- Essential productivity plugins via zplug
- Smart directory jumping with zoxide
- Git integration and aliases

### Neovim Setup
- AstroNvim distribution with custom plugins
- Claude remote control integration
- Language servers for TypeScript, Python, Rust, Go
- Catppuccin Mocha theme matching terminal

### Claude Integration
- Direct buffer control from Claude
- Line highlighting capabilities
- File reading and navigation
- Terminal integration

## 🔧 Customization

### Machine-Specific Settings
Edit `~/.config/chezmoi/chezmoi.toml`:
```toml
[data.system]
    is_work_machine = true     # Customize per machine
    has_docker = true
    shell_theme = "catppuccin-mocha"
```

### Adding New Configurations
```bash
# Add new files/directories
chezmoi add ~/.config/new-app

# Edit configurations
chezmoi edit ~/.zshrc

# Apply changes
chezmoi apply
```

## 📋 Daily Usage

```bash
# Update dotfiles from git
chezmoi update

# Edit configuration
chezmoi edit ~/.zshrc

# See what would change
chezmoi diff

# Apply changes
chezmoi apply

# Commit and push changes
chezmoi cd
git add . && git commit -m "Update config"
git push
```

## 🆘 Troubleshooting

### Neovim Issues
```bash
# Reset Neovim setup
rm -rf ~/.local/share/nvim
nvim  # Will reinstall plugins
```

### zplug Issues
```bash
# Reinstall plugins
zplug install

# Update plugins
zplug update
```

### Claude Integration Issues
```bash
# Check if control script exists
ls -la ~/.local/bin/nvim-claude

# Test Claude integration
nvim-claude list-buffers
```

## 🔄 Updating

To update your dotfiles on all machines:
1. Make changes on one machine
2. Commit and push to git
3. On other machines run: `chezmoi update`

---

*This setup provides a complete, reproducible development environment across all machines!*