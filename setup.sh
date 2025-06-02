#!/usr/bin/env bash

if [ -f ./lib/shared.sh ]; then
    source "./lib/shared.sh"
    source "./lib/colours.sh"
fi

if ! is_arch; then
    error "Arch Linux is not detected. These dotfiles are only intended for Arch Linux."
    error "Exiting..."
    exit 1
fi

info "Arch Linux detected."

info "Beginning dotfiles setup..."
info "Symlinking configuration files..."

# In Folders

symlink_dotfiles "autostart/" "$(xdg_config_dir)"
symlink_dotfiles "dunst/" "$(xdg_config_dir)"
symlink_dotfiles "eww/" "$(xdg_config_dir)"
symlink_dotfiles "hypr/" "$(xdg_config_dir)"
symlink_dotfiles "lib/" "$(xdg_config_dir)"
symlink_dotfiles "nvim/" "$(xdg_config_dir)"
symlink_dotfiles "scripts/" "$(xdg_config_dir)"
symlink_dotfiles "tofi/" "$(xdg_config_dir)"
symlink_dotfiles "uwsm/" "$(xdg_config_dir)"
symlink_dotfiles "wezterm/" "$(xdg_config_dir)"
symlink_dotfiles "yazi/" "$(xdg_config_dir)"
symlink_dotfiles "zellij/" "$(xdg_config_dir)"

mkdir -p "$(xdg_config_dir)/wireplumber"
mkdir -p "$(xdg_data_dir)/wireplumber"
symlink_dotfiles "wireplumber/wireplumber.conf.d/" "$(xdg_config_dir)/wireplumber/"
symlink_dotfiles "wireplumber/scripts/" "$(xdg_data_dir)/wireplumber/"

# # Loose
symlink_dotfiles "monokai_reference.json" "$(xdg_config_dir)/monokai_reference.json"
symlink_dotfiles "spotify-launcher.conf" "$(xdg_config_dir)/spotify-launcher.conf"
symlink_dotfiles "starship.toml" "$(xdg_config_dir)/starship.toml"
symlink_dotfiles ".bashrc" "$HOME/.bashrc"








