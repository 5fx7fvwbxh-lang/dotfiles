# Platform Compatibility Guide

This dotfiles repository is compatible with **macOS** and **Linux (Debian/Ubuntu)**.

## Supported Platforms

- **macOS**: macOS 10.12+ (Sierra and later)
- **Linux**: Debian/Ubuntu-based distributions (Focal, Jammy, Bookworm, etc.)

## Installation

### macOS

#### Quick Start
```bash
git clone --recursive https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

The `install` script will:
1. Check for required packages (git, zsh, tmux, vim)
2. If missing, show you Homebrew installation commands
3. Initialize dotbot submodules
4. Run dotbot to set up all symlinks and configurations

#### Manual Setup (if needed)
If you prefer to install dependencies manually first:
```bash
brew install git zsh tmux vim
```

### Linux (Debian/Ubuntu)

#### Quick Start
```bash
git clone --recursive https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

The `install` script will:
1. Check for required packages (git, zsh, tmux, vim)
2. If missing, show you apt installation commands for your distro
3. Initialize dotbot submodules
4. Run dotbot to set up all symlinks and configurations

#### Manual Setup (if needed)
If you prefer to install dependencies manually first:
```bash
sudo apt update
sudo apt install -y git zsh tmux vim
```

#### Optional: Install zsh plugins from package manager
```bash
sudo apt install -y zsh-syntax-highlighting zsh-autosuggestions
```

If these packages are not available, they will be installed from source on first zsh session.

## Platform-Specific Implementation Details

### 1. Dependency Checking

**File**: `install`

The install script now automatically checks for required packages before proceeding:
- **Required**: git, zsh, tmux, vim
- **On macOS**: Shows Homebrew installation commands if packages are missing
- **On Linux**: Shows apt/dnf/pacman commands depending on detected distro
- **Exits with error** if dependencies are not installed, prompting user to install first

### 2. Homebrew Detection (macOS only)

**File**: `zsh/plugins_before.zsh`

Checks for Homebrew installation only on macOS:
```bash
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew >/dev/null 2>&1; then
        echo "brew not found, installing Homebrew..."
        /bin/bash -c "$(curl -fsSL ...install.sh)"
    fi
fi
```

This prevents unnecessary installation attempts on Linux systems.

### 3. Package Management (Homebrew vs APT)

**File**: `zsh/plugins_after.zsh`

The configuration auto-detects the OS and uses the appropriate package manager:
- **macOS**: Uses `brew install` to install zsh plugins
- **Linux**: Shows installation instructions for apt-based systems

```bash
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLUGIN_PREFIX=$(brew --prefix)
    # Uses brew for installation
else
    PLUGIN_PREFIX="/usr"
    # Shows apt installation instructions
fi
```

### 4. Plugin Paths

Different systems store zsh plugins in different locations:
- **macOS with Homebrew**: `/opt/homebrew/share/` or `/usr/local/share/`
- **Linux with APT**: `/usr/share/`

The `PLUGIN_PREFIX` variable abstracts this difference.

### 5. Utility Commands

**File**: `shell/functions.sh`

The `here()` function has a fallback for systems without `realpath`:
- **Modern systems** (macOS 10.15+, Linux): Uses `realpath`
- **Older systems**: Falls back to `cd` + `pwd`

```bash
if command -v realpath &> /dev/null; then
    loc=$(realpath "$target_path")
else
    loc=$(cd "$target_path" && pwd)
fi
```

### 6. Shell Aliases

**File**: `shell/aliases.sh`

The `ls` alias detects the OS and uses appropriate flags:
- **macOS**: `ls -G` (colorized output)
- **Linux**: `ls --color=auto` (ANSI colors)

