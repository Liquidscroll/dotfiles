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
    to_install=()
    for pkg in "${ARCH_PACKAGES[@]}"; do
        if package_installed "$pkg"; then
            info "$pkg already installed. Skipping."
        elif conflicting_package_installed "$pkg"; then
            info "A conflicting package for $pkg is installed. Skipping."
        else
            to_install+=("$pkg")
        fi
    done
    if [[ ${#to_install[@]} -gt 0 ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            info "(dry-run) Would install pacman packages: ${to_install[*]}"
        else
            info "Installing pacman packages: ${to_install[*]}"
            sudo pacman -S --needed "${to_install[@]}" && success "Pacman packages installed." || error "Failed to install pacman packages."
        fi
    fi
fi

if [[ ${#AUR_PACKAGES[@]} -gt 0 ]]; then
    aur_to_install=()
    for pkg in "${AUR_PACKAGES[@]}"; do
        if package_installed "$pkg"; then
            info "$pkg already installed. Skipping."
        elif conflicting_package_installed "$pkg"; then
            info "A conflicting package for $pkg is installed. Skipping."
        else
            aur_to_install+=("$pkg")
        fi
    done
    if [[ ${#aur_to_install[@]} -gt 0 ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            info "(dry-run) Would install AUR packages: ${aur_to_install[*]}"
        else
            if command_exists yay; then
                info "Installing AUR packages: ${aur_to_install[*]}"
                yay -S "${aur_to_install[@]}" && success "AUR packages installed." || error "Failed to install AUR packages."
            else
                error "'yay' is required to install AUR packages."
            fi
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
