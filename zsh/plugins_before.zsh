# External plugins (initialized before)

# zsh-completions
fpath=(~/.zsh/plugins/zsh-completions/src $fpath)

# check if brew is installed
if ! command -v brew >/dev/null 2>&1; then
    echo "brew not found, installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi