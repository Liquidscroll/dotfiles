# shellcheck shell=bash      # Hint for ShellCheck static analysis
# ~/.profile                 # Login-shell startup file

# ── Launch uwsm session if appropriate ────────────────────────────────────────
if uwsm check may-start >/dev/null && uwsm select; then      # Query/select session
    exec uwsm start default                       # Replace shell with uwsm
fi

# ── Helper: append directories to PATH if present ─────────────────────────────
add_paths() {
    local dir_no_slash
    for d in "$@"; do
        dir_no_slash="${d}"                       # Input dir, unmodified
        # Add only when directory exists and isn’t already in PATH
        if [[ -d "$dir_no_slash" && ! ":$PATH:" == *":$dir_no_slash:"* ]]; then
            PATH="$PATH:$dir_no_slash"
        fi
    done
}

add_paths "$HOME/.local/bin" "$HOME/.cargo/bin"   # User-level binaries
export PATH                                        # Export updated PATH

# ── Per-tool environment initialisation ───────────────────────────────────────
# Load Cargo environment (adds rustup toolchains, etc.)
# shellcheck source="/home/liquidscroll/.cargo/env"
[ -s "$HOME/.cargo/env" ]  && . "$HOME/.cargo/env"      
# Load Atuin environment (history sync CLI) 
# shellcheck source="/home/liquidscroll/.atuin/bin/env"
[ -s "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

# ── SSH key caching via keychain ──────────────────────────────────────────────
eval "$(keychain --eval --quiet ls_github_ed25519 ls_forgejo_ed25519)"

# ── Locale & editor/pager preferences ────────────────────────────────────────
export LANG=en_AU.UTF-8       # System locale (typo fixed from UTR-8 → UTF-8)
export EDITOR=nvim            # Default CLI editor
export VISUAL=$EDITOR         # Default visual editor
export PAGER=less             # Default pager
