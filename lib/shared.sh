#!/usr/bin/env bash

# Check if a command exists
function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Source a file if it exists
function source_if_exists() {
    local file="$1"
    if [ -f "$file" ]; then
        source "$file"
    else
        echo "Sourcing $file failed, file not found."
    fi
}

# Get the base dotfiles directory (assumes this script is in dotfiles/lib/)
_symlinks_current_dir="${BASH_SOURCE%/*}"

function dotfiles_location() {
  echo "$(cd $_symlinks_current_dir/.. && pwd)"
}

source_if_exists "$(dotfiles_location)/lib/colours.sh"
# Allow external scripts to set DRY_RUN; default to false
: "${DRY_RUN:=false}"
function symlink_dotfiles() {
    local file_rel_path="$1"
    local dest="$2"

    local src
    src="$(dotfiles_location)/${file_rel_path%/}"
    if [[ ! -e "$src" ]]; then
        error "Source does not exist: $src"
        return 1
    fi


    dest="${dest%/}"
    #If src is a dir AND dest is an existing dir,
    #then put the link INSIDE dest using the same basename
    if [[ -d "$src" && -d "$dest" && ! -L "$dest" ]]; then
        dest="$dest/$(basename "$src")"
    fi

    local parent_dir
    parent_dir="$(dirname "$dest")"
    if [[ ! -d "$parent_dir" ]]; then
        info "Creating parent directory: $parent_dir"
        if [[ "$DRY_RUN" != true ]]; then
            mkdir -p "$parent_dir"
        fi
    fi
    if [[ "$DRY_RUN" == true ]]; then
        info "(dry-run) Would symlink $src -> $dest"
        return 0
    fi
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
        info "Already symlinked: $dest -> $src"
        return 0
    fi

    if [[ -e "$dest" ]]; then
        error "Destination exists and is: $dest"
        return 1
    fi

    info "Symlinking $src -> $dest"

    if ln -s "$src" "$dest"; then
        success "Linked $src -> $dest"
        return 0
    else
        error "Failed to link $src -> $dest"
        return 1
    fi
}

# Ensure a git repo is cloned
function ensure_git_clone() {
  local repo="$1"
  local destination="$2"

  if [ ! -d "$destination" ]; then
    git clone "$repo" "$destination"
  fi
}

# Add directores to PATH if they exist and aren't already there.
add_paths() {
    local dir_no_slash
    for d in "$@"; do
        dir_no_slash="${d}"
        if [[ -d "$dir_no_slash" && ! ":$PATH:" == *":$dir_no_slash:"* ]]; then
            PATH="$PATH:$dir_no_slash"
        fi
    done
}

# Detect current OS
_current_os="$(uname)"

function is_macos() {
  [[ "$_current_os" == "Darwin" ]]
}

function is_linux() {
  [[ "$_current_os" == "Linux" ]]
}


function is_windows() {
  [[ "$_current_os" =~ MINGW|MSYS|CYGWIN|NT* ]]
}

function is_arch() {
    [[ "$(grep '^ID=' /etc/os-release | cut -d '=' -f2)" == "arch" ]]
}

function is_sudo() {
    [[ "$EUID" -eq 0 ]]
}

# Detect if running Hyprland
function is_hyprland() {
  [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]
}

# XDG locations
function xdg_config_dir() {
  echo "${XDG_CONFIG_HOME:-$HOME/.config}"
}

function xdg_data_dir() {
  echo "${XDG_DATA_HOME:-$HOME/.local/share}"
}

# Check if a package is installed
function package_installed() {
    pacman -Qq "$1" >/dev/null 2>&1
}

# Check if a conflicting package with the same base name is installed
function conflicting_package_installed() {
    pacman -Qq | grep -q "^$1-"
}
