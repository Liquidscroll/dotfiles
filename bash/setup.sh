#!/usr/bin/env bash

set -eo pipefail # Exit on error

# Handle running inside dotfiles/bash or just dotfiles/
if [ -f ../lib/shared.sh ]; then
    source ../lib/shared.sh
elif [ -f ./lib/shared.sh ]; then
    source ./lib/shared.sh
else
    echo "lib/shared.sh does not exist, sourcing failed..."
    exit 1
fi

info "Beginning dotfiles setup..."

function ensure_git_installed() {
    if ! command_exists git; then
        error "Git is not installed, please install git and rerun setup."
        exit 1
    else
        success "Git is installed."
    fi
}


info "Checking for git..."
ensure_git_installed

info "Symlinking shared bash libs..."
symlink_dotfile "lib/shared.sh" "$(xdg_config_dir)/lib/shared.sh"
symlink_dotfile "lib/colours.sh" "$(xdg_config_dir)/lib/colours.sh"

# TODO: install spotify-launcher
info "Symlinking spotify-launcher configuration..."
symlink_dotfile "spotify-launcher.conf" "$(xdg_config_dir)/spotify-launcher.conf"

# TODO: install starship
info "Symlinking Starship prompt configuration..."
symlink_dotfile "starship.toml" "$(xdg_config_dir)/starship.toml"

# TODO: install hyprland
symlink_dotfile "hypr/hyprland.conf" "$(xdg_config_dir)/hypr/hyprland.conf"
symlink_dotfile "hypr/hyprpaper.conf" "$(xdg_config_dir)/hypr/hyprpaper.conf"

# TODO: install uwsm
# symlink config + env

# TODO: install wezterm
# TODO: symlink config

# TODO: install zellij
symlink_dotfile "zellij/config.kdl" "$(xdg_config_dir)/zellij/config.kdl"
