#!/usr/bin/env bash

set -eo pipefail # Exit on error

if [ -f ../lib/shared.sh ]; then
    source ../lib/shared.sh
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

