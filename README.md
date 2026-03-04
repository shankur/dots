# Cross-Platform Development Environment

This dotfiles setup works across **macOS**, **Amazon Linux**, **Ubuntu**, and other distributions.

## 🚀 Quick Setup

### **Any Platform**
```bash
# Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME
```

### **Amazon Linux Specific Setup**

1. **Install basic dependencies:**
   ```bash
   sudo yum update -y
   sudo yum install -y git curl zsh
   ```

2. **Install development tools:**
   ```bash
   sudo yum groupinstall -y "Development Tools"
   sudo yum install -y gcc gcc-c++
   ```

3. **Apply dotfiles:**
   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME
   ```

4. **Change default shell** (optional):
   ```bash
   chsh -s $(which zsh)
   ```

## 🎯 What Gets Installed

### **macOS (Homebrew)**
- GCC 15 (g++-15, gcc-15)
- Modern CLI tools: fd, eza, ripgrep, zoxide
- Zsh plugins: autosuggestions, syntax-highlighting
- Starship prompt

### **Amazon Linux/RHEL**
- System GCC with C++23 support
- Modern CLI tools (compiled from source if needed)
- Zsh plugins (cloned from GitHub)
- Starship prompt

### **Ubuntu/Debian**
- System GCC with C++23 support
- Modern CLI tools via apt
- Zsh plugins via package manager
- Starship prompt

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

## 🔄 Updates

To update your setup:
```bash
chezmoi update
```

To add new configurations:
```bash
chezmoi add ~/.config/new-tool
```

## 🌍 Supported Platforms

✅ **macOS** (Apple Silicon + Intel)
✅ **Amazon Linux 2/2023**
✅ **Ubuntu 20.04+**
✅ **Debian 11+**
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

## 🎯 Example: Amazon Linux Setup

```bash
# 1. SSH into Amazon Linux instance
ssh ec2-user@your-instance-ip

# 2. One-command setup
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME

# 3. Restart shell or source config
exec zsh

# 4. Enjoy your portable development environment!
ls    # Now uses eza with icons
z ~   # Smart navigation with zoxide
```

That's it! Your complete development environment is now available on any platform. 🎉
