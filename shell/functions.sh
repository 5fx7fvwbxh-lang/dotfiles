path_remove() {
    PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: "\$0 != \"$1\"" | sed 's/:$//')
}

path_append() {
    path_remove "$1"
    PATH="${PATH:+"$PATH:"}$1"
}

path_prepend() {
    path_remove "$1"
    PATH="$1${PATH:+":$PATH"}"
}

here() {
    local loc
    local target_path
    if [ "$#" -eq 1 ]; then
        target_path="$1"
    else
        target_path="."
    fi
    
    # Use realpath if available (macOS 10.15+, Linux), fallback to cd/pwd
    if command -v realpath &> /dev/null; then
        loc=$(realpath "$target_path")
    else
        loc=$(cd "$target_path" && pwd)
    fi
    
    ln -sfn "${loc}" "$HOME/.shell.here"
    echo "here -> $(readlink $HOME/.shell.here)"
}

there="$HOME/.shell.here"

there() {
    cd "$(readlink "${there}")"
}