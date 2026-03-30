# Cross-Platform Development Environment

This dotfiles setup works across **macOS**, **NixOS**, **Ubuntu**, **Amazon Linux**, and other distributions.

## 🚀 Quick Setup (One Command)

### **New Machine Setup**
```bash
# Install and configure everything
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/shankur/dots.git
```

**First time setup:** You'll be prompted for your name and email for git config.

**That's it!** Everything installs automatically:
- ✅ All CLI tools (eza, fd, ripgrep, zoxide, starship, bat, delta)
- ✅ Shell plugins (autosuggestions, syntax highlighting)
- ✅ Neovim configuration
- ✅ Tmux, Git, and all configs

Then restart your shell:
```bash
exec zsh
```

## 🎯 What Gets Installed

### **macOS (Homebrew)**
- Modern CLI tools: fd, eza, ripgrep, zoxide, starship, bat, delta
- Development tools: git, neovim, tmux, go, rust, node, python3
- Zsh plugins: autosuggestions, syntax-highlighting

### **NixOS (Nix)**
- Modern CLI tools: fd, eza, ripgrep, zoxide, starship, bat, delta
- Development tools: git, neovim, tmux, go, rust, node, python3
- Zsh plugins: autosuggestions, syntax-highlighting

### **Ubuntu/Debian (apt)**
- Modern CLI tools: fd, eza, ripgrep, bat (via apt + cargo)
- Development tools: git, neovim, tmux, go, node, python3
- Zsh plugins via package manager
- Rust tools (starship, zoxide) via cargo

### **Amazon Linux/RHEL (dnf/yum)**
- Development tools: git, neovim, tmux, go, node, python3
- Modern CLI tools compiled via cargo
- Zsh plugins (cloned from GitHub)

## 🔧 Platform-Specific Features

The configuration automatically adapts:

### **Compiler Paths**
- **macOS**: `g++-15`, `gcc-15` (Homebrew GCC)
- **Linux**: `g++`, `gcc` (system GCC)

### **Tool Locations**
- **macOS**: `/opt/homebrew/` paths
- **Linux**: `/usr/share/` or `/usr/local/` paths

### **Package Sources**
- **macOS**: Homebrew packages
- **Amazon Linux**: yum/dnf + GitHub releases
- **Ubuntu**: apt packages + GitHub releases

## 🧪 Testing Your Setup

After installation, test these commands:

```bash
# Test modern CLI tools
ls          # Should use eza
find . -name "*.txt"  # Should use fd
grep -i "test" file   # Should use ripgrep
z ~/Desktop          # Should use zoxide

# Test C++ compilation
echo 'int main(){return 0;}' > test.cpp
g++ test.cpp -o test  # Should use C++23 flags
./test

# Test C compilation
echo 'int main(){return 0;}' > test.c
gcc test.c -o test    # Should use C23 flags
./test
```

## 🐛 Debugging Setup

**Neovim debugging works on all platforms:**
- **F5** - Start debugging
- **F10** - Step over
- **<leader>db** - Toggle breakpoint

**Platform differences:**
- **macOS**: Uses `g++-15` for compilation
- **Linux**: Uses `g++` for compilation

## 🔍 Troubleshooting

### **Amazon Linux Issues**

**Missing packages:**
```bash
# Enable EPEL for additional packages
sudo yum install -y epel-release

# Install from source if package not available
curl -L https://github.com/TOOL/releases/latest/download/TOOL.tar.gz | tar xz
```

**Zsh not default:**
```bash
# Make zsh default shell
sudo yum install -y util-linux-user
chsh -s /usr/bin/zsh
```

**Old GCC version:**
```bash
# Check GCC version
gcc --version

# Install newer GCC if needed (Amazon Linux 2)
sudo yum install -y gcc10 gcc10-c++
# Then update aliases to use gcc10/g++10
```

## 🎯 Customization

Edit these template files to customize per-platform:

- `.zshrc.tmpl` - Shell configuration
- `run_once_install-dev-tools.sh.tmpl` - Installation script
- `nvim/lua/plugins/debug.lua.tmpl` - Debug configuration

## ⚙️ Chezmoi Configuration Management

### **Machine-Specific vs Shared Config**

**Chezmoi's own config file** (`~/.config/chezmoi/chezmoi.toml`) **cannot be tracked directly** to prevent recursive configuration loops. You have two options:

#### **Option 1: Keep Machine-Specific (Recommended)**
```bash
# Leave ~/.config/chezmoi/chezmoi.toml untracked
# Perfect for personal settings that differ per machine:
# - Email addresses (work vs personal)
# - Machine-specific flags (is_work_machine, has_docker)
# - Different editor preferences
```

#### **Option 2: Use Config Template (Advanced)**
For shared config with machine-specific variables:

1. **Create config template:**
   ```bash
   touch .chezmoi.toml.tmpl
   ```

2. **Template example:**
   ```toml
   [data]
       name = "Your Name"
   {{- if eq .chezmoi.hostname "work-laptop" }}
       email = "work@company.com"
       is_work_machine = true
   {{- else }}
       email = "personal@email.com"
       is_work_machine = false
   {{- end }}

   [edit]
       command = "nvim"

   {{- if eq .chezmoi.os "darwin" }}
   [data.system]
       shell_theme = "catppuccin-mocha"
   {{- end }}
   ```

3. **Deploy with variables:**
   ```bash
   chezmoi init --apply YOUR_USERNAME
   ```

**💡 Most users should stick with Option 1** - keep the config machine-specific for simplicity.

## 🔄 Updates & Management

**Update dotfiles:**
```bash
chezmoi update
```

**Add new config files:**
```bash
chezmoi add ~/.config/new-tool
```

**Edit a config file:**
```bash
chezmoi edit ~/.zshrc
```

## 🔍 Manual Configuration (Optional)

If the automatic setup didn't prompt you, create git config manually:

```bash
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << EOF
[data]
    name = "Your Name"
    email = "your.email@example.com"
EOF
```

Then apply:
```bash
chezmoi apply
```

## 🌍 Supported Platforms

✅ **macOS** (Apple Silicon + Intel)
✅ **NixOS** (via nix-env)
✅ **Ubuntu 20.04+**
✅ **Debian 11+**
✅ **Amazon Linux 2/2023**
✅ **RHEL 8+**
⚠️ **CentOS** (with manual package installation)

Your development environment is now **truly portable**! 🚀

## 📋 What's Included

### **Modern CLI Tools**
- `eza` - Better ls with icons and colors
- `fd` - Better find, faster and more intuitive
- `ripgrep` - Better grep, incredibly fast
- `zoxide` - Smart cd that learns your habits

### **Development Environment**
- **C++23** support with modern GCC
- **C23** support for latest C features
- **Neovim** with full debugging setup
- **Enhanced diffview** with comment system
- **LSP servers** for multiple languages

### **Shell Experience**
- **Zsh** with smart completions
- **Starship** prompt with git integration
- **Syntax highlighting** and **autosuggestions**
- **Cross-platform** aliases that adapt automatically

## 🎨 Theme & UI

- **Catppuccin Mocha** theme across terminal and Neovim
- **Consistent experience** across all platforms
- **Beautiful** syntax highlighting and prompts

## 🚀 Example: Remote Server Setup

```bash
# SSH into any remote server (NixOS, Ubuntu, Amazon Linux, etc.)
ssh user@remote-server

# One command to set up everything
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/shankur/dots.git

# Restart shell
exec zsh

# Enjoy your complete dev environment!
ls    # Now uses eza with icons
z ~   # Smart navigation with zoxide
```

That's it! Your complete development environment is now available on any platform. 🎉
