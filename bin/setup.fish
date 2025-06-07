#!/usr/bin/env fish

if test -f ./lib/shared.fish
    source ./lib/shared.fish
    source ./lib/colours.fish
end

set DRY_RUN false
while test (count $argv) -gt 0
    switch $argv[1]
        case '--dry-run' '-n'
            set DRY_RUN true
        case '*'
            error "Unknown option: $argv[1]"
            exit 1
    end
    set argv $argv[2..-1]
end

set -gx DRY_RUN $DRY_RUN

if not is_arch
    error "Arch Linux is not detected. These dotfiles are only intended for Arch Linux."
    exit 1
end

info "Arch Linux detected."

info "Beginning dotfiles setup..."
if test $DRY_RUN = true
    info "Dry-run mode enabled. No files will be modified."
end
info "Symlinking configuration files..."

symlink_dotfiles "autostart/" (xdg_config_dir) || exit 1
symlink_dotfiles "dunst/" (xdg_config_dir) || exit 1
symlink_dotfiles "eww/" (xdg_config_dir) || exit 1
symlink_dotfiles "hypr/" (xdg_config_dir) || exit 1
symlink_dotfiles "lib/" (xdg_config_dir) || exit 1
symlink_dotfiles "nvim/" (xdg_config_dir) || exit 1
symlink_dotfiles "scripts/" (xdg_config_dir) || exit 1
symlink_dotfiles "tofi/" (xdg_config_dir) || exit 1
symlink_dotfiles "uwsm/" (xdg_config_dir) || exit 1
symlink_dotfiles "wezterm/" (xdg_config_dir) || exit 1
symlink_dotfiles "zellij/" (xdg_config_dir) || exit 1

if test $DRY_RUN = true
    info "(dry-run) Would create (xdg_config_dir)/wireplumber"
    info "(dry-run) Would create (xdg_data_dir)/wireplumber"
else
    mkdir -p (xdg_config_dir)/wireplumber
    mkdir -p (xdg_data_dir)/wireplumber
end
symlink_dotfiles "wireplumber/wireplumber.conf.d/" (xdg_config_dir)/wireplumber/ || exit 1
symlink_dotfiles "wireplumber/scripts/" (xdg_data_dir)/wireplumber/ || exit 1
symlink_dotfiles "monokai_reference.json" (xdg_config_dir)/monokai_reference.json || exit 1
symlink_dotfiles "spotify-launcher.conf" (xdg_config_dir)/spotify-launcher.conf || exit 1
symlink_dotfiles "starship.toml" (xdg_config_dir)/starship.toml || exit 1
symlink_dotfiles ".bashrc" "$HOME/.bashrc" || exit 1
symlink_dotfiles "fish/config.fish" "$HOME/.config/fish/config.fish" || exit 1

success "Configuration complete."
