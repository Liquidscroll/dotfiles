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
if [[ "$EUID" -ne 0 ]]; then
    info "This script needs to install packages and may require root privileges."
    info "You will be prompted for your sudo password once if needed."
    if sudo -v; then # Ask for password upfront and refresh sudo timestamp
        success "Sudo credentials refreshed."
    else
        error "Failed to obtain sudo credentials. Exiting."
        exit 1
    fi
else
    info "Error script should not be run as root, due to use of yay commands."
    exit 1
fi

info "Beginning dotfiles setup..."

info "Symlinking shared bash libs..."
symlink_dotfiles "lib/shared.sh" "$(xdg_config_dir)/lib/shared.sh"
symlink_dotfiles "lib/colours.sh" "$(xdg_config_dir)/lib/colours.sh"

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
mkdir -p "$(xdg_config_dir)/hypr"
symlink_dotfiles "hypr/hyprland.conf" "$(xdg_config_dir)/hypr/hyprland.conf"

if ! command_exists hyprpaper; then
    info "Installing hyprpaper with pacman..."
    sudo pacman -S hyprpaper
fi
symlink_dotfiles "hypr/hyprpaper.conf" "$(xdg_config_dir)/hypr/hyprpaper.conf"

if ! command_exists spotify-launcher; then
    info "Installing spotify-launcher with pacman..."
    sudo pacman -S spotify-launcher
fi
success "spotify-launcher installed."
symlink_dotfiles "spotify-launcher.conf" "$(xdg_config_dir)/spotify-launcher.conf"

if ! command_exists starship; then
    info "Installing starship with pacman..."
    sudo pacman -S starship
fi
success "starship.rs installed."
symlink_dotfiles "starship.toml" "$(xdg_config_dir)/starship.toml"

if ! command_exists uwsm; then
    info "Installing uwsm..."
    sudo pacman -S uwsm libnewt
fi
success "uwsm installed."
mkdir -p "$(xdg_config_dir)/uwsm"
symlink_dotfiles "uwsm/env" "$(xdg_config_dir)/uwsm/env"
symlink_dotfiles "uwsm/env-hyprland" "$(xdg_config_dir)/uwsm/env-hyprland"

if ! command_exists wezterm; then
    info "Installing wezterm-git with yay and nerd fonts with pacman..."
    sudo pacman -S ttf-nerd-fonts-symbols-mono
    yay -S wezterm-git
fi
success "Wezterm installed."
mkdir -p "$(xdg_config_dir)/wezterm"
symlink_dotfiles "wezterm/wezterm.lua" "$(xdg_config_dir)/wezterm/wezterm.lua"

if ! command_exists zellij; then
    info "Installing zellij with pacman..."
    sudo pacman -S zellij
fi
success "zellij installed."
mkdir -p "$(xdg_config_dir)/zellij"
symlink_dotfiles "zellij/config.kdl" "$(xdg_config_dir)/zellij/config.kdl"

if ! command_exists nvim; then
    info "Installing neovim-git with yay..."
    yay -S neovim-git
fi
success "Neovim installed."
symlink_dotfiles "nvim/" "$(xdg_config_dir)/"
