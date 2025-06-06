#!/usr/bin/env bash

if [ -f ./lib/shared.sh ]; then
    source "./lib/shared.sh"
    source "./lib/colours.sh"
fi

# Parse arguments
DRY_RUN=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run|-n)
            DRY_RUN=true
            ;;
        *)
            error "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

# Export so shared library can see it
export DRY_RUN

if ! is_arch; then
    error "Arch Linux is not detected. These dotfiles are only intended for Arch Linux."
    error "Exiting..."
    exit 1
fi

info "Arch Linux detected."

info "Beginning dotfiles setup..."
if [[ "$DRY_RUN" == true ]]; then
    info "Dry-run mode enabled. No files will be modified."
fi
info "Symlinking configuration files..."

# In Folders

symlink_dotfiles "autostart/" "$(xdg_config_dir)" || exit 1
symlink_dotfiles "dunst/" "$(xdg_config_dir)" || exit 1
symlink_dotfiles "eww/" "$(xdg_config_dir)" || exit 1
symlink_dotfiles "hypr/" "$(xdg_config_dir)" || exit 1
symlink_dotfiles "lib/" "$(xdg_config_dir)" || exit 1
symlink_dotfiles "nvim/" "$(xdg_config_dir)" || exit 1
symlink_dotfiles "scripts/" "$(xdg_config_dir)" || exit 1
symlink_dotfiles "tofi/" "$(xdg_config_dir)" || exit 1
symlink_dotfiles "uwsm/" "$(xdg_config_dir)" || exit 1
symlink_dotfiles "wezterm/" "$(xdg_config_dir)" || exit 1
symlink_dotfiles "zellij/" "$(xdg_config_dir)" || exit 1

mkdir -p "$(xdg_config_dir)/wireplumber"
mkdir -p "$(xdg_data_dir)/wireplumber"
symlink_dotfiles "wireplumber/wireplumber.conf.d/" "$(xdg_config_dir)/wireplumber/" || exit 1
symlink_dotfiles "wireplumber/scripts/" "$(xdg_data_dir)/wireplumber/" || exit 1
# # Loose
symlink_dotfiles "monokai_reference.json" "$(xdg_config_dir)/monokai_reference.json" || exit 1
symlink_dotfiles "spotify-launcher.conf" "$(xdg_config_dir)/spotify-launcher.conf" || exit 1
symlink_dotfiles "starship.toml" "$(xdg_config_dir)/starship.toml" || exit 1
symlink_dotfiles ".bashrc" "$HOME/.bashrc" || exit 1
success "Configuration complete."
