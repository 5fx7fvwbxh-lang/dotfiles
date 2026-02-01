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

# Auto-activate Python virtualenv if available
auto_activate_venv() {
    # Deactivate any currently active virtualenv first
    if [[ -n "$VIRTUAL_ENV" ]]; then
        deactivate 2>/dev/null
    fi

    local venv_dir

    # Check for common venv directory names first (most common)
    for dir in venv .venv env .env; do
        if [[ -f "$dir/pyvenv.cfg" ]]; then
            venv_dir="$dir"
            break
        fi
    done

    # Search for any directory containing pyvenv.cfg (up to 2 levels deep)
    if [[ -z "$venv_dir" ]]; then
        # Look for pyvenv.cfg exactly two levels down (./<subdir>/pyvenv.cfg)
        local match=$(find . -mindepth 2 -maxdepth 2 -name "pyvenv.cfg" -type f 2>/dev/null | head -1)
        if [[ -n "$match" ]]; then
            venv_dir=$(dirname "$match")
        fi
    fi

    # Activate the virtualenv if found
    if [[ -n "$venv_dir" && -f "$venv_dir/bin/activate" ]]; then
        # Prevent the venv activation script from overriding the shell prompt
        export VIRTUAL_ENV_DISABLE_PROMPT=1
        source "$venv_dir/bin/activate"
        unset VIRTUAL_ENV_DISABLE_PROMPT
    fi
}