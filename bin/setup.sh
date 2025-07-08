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
symlink_dotfiles "zellij/" "$(xdg_config_dir)" 
# symlink_dotfiles "atuin/" "$(xdg_config_dir)" 

if [[ "$DRY_RUN" == true ]]; then
    info "(dry-run) Would create $(xdg_config_dir)/wireplumber"
    info "(dry-run) Would create $(xdg_data_dir)/wireplumber"
else
    mkdir -p "$(xdg_config_dir)/wireplumber"
    mkdir -p "$(xdg_data_dir)/wireplumber"
fi
symlink_dotfiles "wireplumber/wireplumber.conf.d/" "$(xdg_config_dir)/wireplumber/" 
symlink_dotfiles "wireplumber/scripts/" "$(xdg_data_dir)/wireplumber/" 
# # Loose
symlink_dotfiles "monokai_reference.json" "$(xdg_config_dir)/monokai_reference.json" 
symlink_dotfiles "spotify-launcher.conf" "$(xdg_config_dir)/spotify-launcher.conf" 
symlink_dotfiles "starship.toml" "$(xdg_config_dir)/starship.toml" 
symlink_dotfiles ".bashrc" "$HOME/.bashrc" 
symlink_dotfiles ".bash_profile" "$HOME/.bash_profile" 
symlink_dotfiles ".profile" "$HOME/.profile" 
symlink_dotfiles "scripts/archive_notes.sh" "$HOME/.local/bin/archive_notes.sh" 
if [[ "$DRY_RUN" == true ]]; then
    info "(dry-run) Would create $(xdg_config_dir)/systemd/user/"
else
    mkdir -p "$(xdg_config_dir)/systemd/user/"
fi
symlink_dotfiles "systemd/user/archive-notes.service" "$(xdg_config_dir)/systemd/user/archive-notes.service" 
symlink_dotfiles "systemd/user/archive-notes.timer" "$(xdg_config_dir)/systemd/user/archive-notes.timer" 
symlink_dotfiles "fish/config.fish" "$(xdg_config_dir)/fish/config.fish" 
success "Configuration complete."
