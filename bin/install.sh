#!/usr/bin/env bash

# Source shared utilities
source "./lib/shared.sh"
source "./lib/colours.sh"

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

export DRY_RUN

if ! is_arch; then
    error "Arch Linux is required for this installation."
    exit 1
fi

ARCH_LIST="packages/arch.txt"
AUR_LIST="packages/aur.txt"

readarray -t ARCH_PACKAGES < <(grep -vE '^\s*(#|$)' "$ARCH_LIST" 2>/dev/null)
readarray -t AUR_PACKAGES < <(grep -vE '^\s*(#|$)' "$AUR_LIST" 2>/dev/null)

if [[ ${#ARCH_PACKAGES[@]} -gt 0 ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        info "(dry-run) Would install pacman packages: ${ARCH_PACKAGES[*]}"
    else
        info "Installing pacman packages: ${ARCH_PACKAGES[*]}"
        sudo pacman -S --needed "${ARCH_PACKAGES[@]}" && success "Pacman packages installed." || error "Failed to install pacman packages."
    fi
fi

if [[ ${#AUR_PACKAGES[@]} -gt 0 ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        info "(dry-run) Would install AUR packages: ${AUR_PACKAGES[*]}"
    else
        if command_exists yay; then
            info "Installing AUR packages: ${AUR_PACKAGES[*]}"
            yay -S "${AUR_PACKAGES[@]}" && success "AUR packages installed." || error "Failed to install AUR packages."
        else
            error "'yay' is required to install AUR packages."
        fi
    fi
fi

info "Running setup.sh..."
if [[ "$DRY_RUN" == true ]]; then
    ./bin/setup.sh --dry-run
else
    ./bin/setup.sh
fi

success "Installation script completed."
