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
# Create a symlink from dotfiles to destination
function symlink_dotfile() {
  local file="$1"
  local destination="$2"
  local full_file_path="$(dotfiles_location)/$file"

  if [ ! -e "$destination" ]; then
    info "Symlinking $full_file_path -> $destination"
    mkdir -p "$(dirname "$destination")"
    ln -s "$full_file_path" "$destination"
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
            info "Adding $dir_no_slash to PATH"
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
