# External plugins (initialized after)

# Syntax highlighting

# Determine prefix based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLUGIN_PREFIX=$(brew --prefix)
else
    PLUGIN_PREFIX="/usr"
fi

# check if zsh-syntax-highlighting is installed
if [ ! -f "$PLUGIN_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    echo "zsh-syntax-highlighting not found, installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install zsh-syntax-highlighting
    else
        echo "Please install zsh-syntax-highlighting using your package manager:"
        echo "  Ubuntu/Debian: sudo apt install zsh-syntax-highlighting"
        sudo apt install zsh-syntax-highlighting
    fi
fi
source $PLUGIN_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# check if zsh-autosuggestions is installed
if [ ! -f "$PLUGIN_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    echo "zsh-autosuggestions not found, installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install zsh-autosuggestions
    else
        echo "Please install zsh-autosuggestions using your package manager:"
        echo "  Ubuntu/Debian: sudo apt install zsh-autosuggestions"
        sudo apt install zsh-autosuggestions
    fi
fi
source $PLUGIN_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

if [[ "$(tput colors)" == "256" ]]; then
    ZSH_HIGHLIGHT_STYLES[default]=none
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=160
    ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=037,bold #,standout
    ZSH_HIGHLIGHT_STYLES[alias]=fg=064,bold
    ZSH_HIGHLIGHT_STYLES[builtin]=fg=064,bold
    ZSH_HIGHLIGHT_STYLES[function]=fg=064,bold
    ZSH_HIGHLIGHT_STYLES[command]=fg=064,bold
    ZSH_HIGHLIGHT_STYLES[precommand]=fg=064,underline
    ZSH_HIGHLIGHT_STYLES[commandseparator]=none
    ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=037
    ZSH_HIGHLIGHT_STYLES[path]=fg=166,underline
    ZSH_HIGHLIGHT_STYLES[globbing]=fg=033
    ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=125,bold
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=125,bold
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=136
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=136
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=136
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=136
    ZSH_HIGHLIGHT_STYLES[assign]=fg=037
fi

# Docker CLI completions
if [ -d ~/.docker/completions ]; then
    fpath=(~/.docker/completions $fpath)
fi
