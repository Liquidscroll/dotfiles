#!/usr/bin/env fish

source ./lib/shared.fish
source ./lib/colours.fish

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
    error "Arch Linux is required for this installation."
    exit 1
end

set ARCH_LIST 'packages/arch.txt'
set AUR_LIST 'packages/aur.txt'

set -l ARCH_PACKAGES (grep -vE '^\s*(#|$)' $ARCH_LIST 2>/dev/null)
set -l AUR_PACKAGES (grep -vE '^\s*(#|$)' $AUR_LIST 2>/dev/null)

if test (count $ARCH_PACKAGES) -gt 0
    if test $DRY_RUN = true
        info "(dry-run) Would install pacman packages: $ARCH_PACKAGES"
    else
        info "Installing pacman packages: $ARCH_PACKAGES"
        sudo pacman -S --needed $ARCH_PACKAGES; and success "Pacman packages installed."; or error "Failed to install pacman packages."
    end
end

if test (count $AUR_PACKAGES) -gt 0
    if test $DRY_RUN = true
        info "(dry-run) Would install AUR packages: $AUR_PACKAGES"
    else
        if command_exists yay
            info "Installing AUR packages: $AUR_PACKAGES"
            yay -S $AUR_PACKAGES; and success "AUR packages installed."; or error "Failed to install AUR packages."
        else
            error "'yay' is required to install AUR packages."
        end
    end
end

info "Running setup.sh..."
if test $DRY_RUN = true
    ./bin/setup.fish --dry-run
else
    ./bin/setup.fish
end

success "Installation script completed."
