# Cross-Platform Development Environment

This dotfiles setup works across **macOS**, **NixOS**, **Ubuntu**, **Amazon Linux**, and other distributions.

## 🚀 Quick Setup (One Command)

### **Work Machine**
```bash
curl -fsSL https://raw.githubusercontent.com/shankur/dots/main/install.sh | bash
```

### **Personal Machine**
```bash
curl -fsSL https://raw.githubusercontent.com/shankur/dots/main/install.sh | bash
```

Chezmoi will interactively prompt for your profile, name, and email on first run.

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

**Check current profile:**
```bash
chezmoi data
```

## 🗂️ Managing Projects (VSCode workspaces + Dock stack)

A small generator turns a **curated list of repos** into VSCode multi-root
workspaces and a macOS Dock **Projects** stack, so you can launch any project
with a click.

**The pieces (all chezmoi-managed):**
- `dot_config/projects-workspace/repos` — the list of projects to track (per-profile — see below)
- `dot_local/bin/executable_gen-projects-workspace` — the generator (Python)
- `dot_local/bin/executable_setup-projects-dock.sh` — adds the Dock stack (macOS-only, idempotent, **manual**)

**Choose which projects appear:**
```bash
chezmoi edit ~/.config/projects-workspace/repos   # one entry per line
gen-projects-workspace                            # rebuild the workspaces
```
Each line is either a **bare repo name** under `~/Projects` (e.g.
`cortex-code-eval`) or an **explicit path** (e.g. `~/.local/share/chezmoi`).
`#` starts a comment. Delete or empty the file to track *every* git repo under
`~/Projects`.

**Work vs. personal:** this curated list only deploys on `profile: work`
machines (see `.chezmoiignore`) — on `profile: personal` machines the file is
never created, so the generator falls back to tracking every git repo under
`~/Projects` automatically. Edit `.chezmoiignore` if you'd rather curate a
personal list too.

**What gets generated** (into `~/Projects/_workspaces/`):
- `all-repos.code-workspace` — every tracked project as one root (open all).
- `<name>.code-workspace` — one per tracked project, so each appears
  individually in the Dock stack. For a repo with multiple git worktrees (e.g.
  `snowflake`) it lists the `main` clone + each worktree as its own root.

Both files seed `workbench.sideBar.location: left` and stale entries are pruned.

**The Dock stack is opt-in, not automatic.** `chezmoi apply` never touches your
Dock or LaunchServices handlers by itself — run it yourself whenever you want
the stack installed (macOS only; it refuses to run on Linux):
```bash
setup-projects-dock
```
It adds a **Projects** stack pointing at `~/Projects/_workspaces/` (list view,
sorted by name, shown with the **VS Code logo**) and points `.code-workspace`
files at VS Code (via an extension-based LaunchServices handler — `duti` can't,
since these files have only a dynamic UTI). It's idempotent — re-running never
duplicates the stack. A one-time reminder to run it prints after your first
`chezmoi init --apply` on a new macOS machine (see
`run_once_after_print-manual-setup-notes.sh.tmpl`); it never runs it for you.
To remove the stack, drag it off the Dock.

**Stays current automatically:** the `wt` worktree helper reruns the generator
on `wt create` / `checkout` / `remove`, so worktree changes appear in the stack
with no manual step.

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

# One command setup
curl -fsSL https://raw.githubusercontent.com/shankur/dots/main/install.sh | bash

# Restart shell
exec zsh

# Enjoy your complete dev environment!
ls    # Now uses eza with icons
z ~   # Smart navigation with zoxide
```

That's it! Your complete development environment is now available on any platform. 🎉
