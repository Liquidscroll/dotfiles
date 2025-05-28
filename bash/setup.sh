#!/usr/bin/env bash

function ensure_git_installed() {
    if ! command_exists git; then
        error "Git is not installed, please install git and rerun setup."
        exit 1
    else
        success "Git found."
    fi
}

function ensure_yay_installed() {
    if ! command_exists yay; then
        error "Yay is not installed, please install yay and rereun setup."
        exit 1
    else
        success "Yay found."
    fi
}


set -eo pipefail # Exit on error


# Handle running inside dotfiles/bash or just dotfiles/
LIB_PATH=""
if [ -f ../lib/shared.sh ]; then
    LIB_PATH="../lib"
elif [ -f ./lib/shared.sh ]; then
    LIB_PATH="./lib"
else
    echo "[ERROR] lib/shared.sh does not exist, sourcing failed..."
    exit 1
fi

source "$LIB_PATH/shared.sh"
source "$LIB_PATH/builds.sh"


if ! is_arch; then
    error "Arch Linux is not detected. These dotfiles are only intended for Arch Linux."
    error "Exiting..."
    exit 1
fi

info "Arch Linux detected."
info "Checking for sudo..."
if [[ "$EUID" -ne 0 ]]; then
    warn "This script needs root privileges for package installation, rerunning as root..."
    exec sudo HOME="$HOME" USER="$USER" bash "$0" "$@"
fi

info "Beginning dotfiles setup..."

info "Symlinking shared bash libs..."
symlink_dotfile "lib/shared.sh" "$(xdg_config_dir)/lib/shared.sh"
symlink_dotfile "lib/colours.sh" "$(xdg_config_dir)/lib/colours.sh"

info "Checking for git..."
ensure_git_installed
info "Checking for yay..."
ensure_yay_installed

# # Hyprland Installation
if command_exists hyprland; then
    success "Hyprland command found, skipping build..."
else
    info "Building and installing hyprland..."
    build_hyprland
    success "Hyprland built and installed."
fi
symlink_dotfile "hypr/hyprland.conf" "$(xdg_config_dir)/hypr/hyprland.conf"
symlink_dotfile "hypr/hyprpaper.conf" "$(xdg_config_dir)/hypr/hyprpaper.conf"

if ! command_exists spotify-launcher; then
    info "Installing spotify-launcher with pacman..."
    sudo pacman -S spotify-launcher
fi
success "spotify-launcher installed."
info "Symlinking spotify-launcher configuration..."
symlink_dotfile "spotify-launcher.conf" "$(xdg_config_dir)/spotify-launcher.conf"

if ! command_exists starship; then
    info "Installing starship with pacman..."
    sudo pacman -S starship
fi
success "spotify-launcher installed."
info "Symlinking Starship prompt configuration..."
symlink_dotfile "starship.toml" "$(xdg_config_dir)/starship.toml"


# TODO: install uwsm
# symlink config + env

# TODO: install wezterm
# TODO: symlink config

if ! command_exists zellij; then
    info "Installing zellij with pacman..."
    sudo pacman -S zellij
fi
success "zellij installed."
symlink_dotfile "zellij/config.kdl" "$(xdg_config_dir)/zellij/config.kdl"
