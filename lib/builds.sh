#!/usr/bin/env bash

function install_hyprland_deps() {
    local pkgs=(ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite libxrender libxcursor pixman wayland-protocols cairo pango libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang-git hyprcursor-git hyprwayland-scanner-git xcb-util-errors hyprutils-git glaze hyprgraphics-git aquamarine-git re2 hyprland-qtutils)
    local to_install=()
    for pkg in "${pkgs[@]}"; do
        if package_installed "$pkg"; then
            info "$pkg already installed. Skipping."
        elif conflicting_package_installed "$pkg"; then
            info "A conflicting package for $pkg is installed. Skipping."
        else
            to_install+=("$pkg")
        fi
    done
    if [[ ${#to_install[@]} -gt 0 ]]; then
        info "Executing command: 'yay -S ${to_install[*]}'"
        yay -S "${to_install[@]}"
    fi
}

function build_hyprland() {
    info "Installing hyprland dependencies..."
    install_hyprland_deps
    info "Building hyprland in ~/builds/hyprland/"
    mkdir -p ~/builds/hyprland/
    git clone --recursive https://github.com/hyprwm/Hyprland ~/builds/hyprland/
    pushd ~/builds/hyprland &> /dev/null
    make all && sudo make install
    popd &> /dev/null
}
