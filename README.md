# Dotfiles

Contains my configurations for:
- `bash/`
    - `.bashrc` and `setup.sh`
    - Shared functions are found in `lib/shared.sh`
    - Colour definitions and messaging functions are found in `lib/colours.sh`
- `hypr/`
    - `hyprland.conf` & `hyprpaper.conf`
- `zellij`
    -`config.kdl`
- `autostart/`
    - Minimal desktop files used to disable the default autostart of
      `blueman-applet`, `nm-applet` and `spotify-launcher`. These applications
      are started from Hyprland instead.
- Spotify launcher: `spotify-launcher.conf`
- Starship prompt: `starship.toml`


At the moment this is a WIP and is intended to only be used on Arch Linux.
Before running, ensure pacman is upgraded with `pacman -Syu`.
Run `./setup.sh` to symlink the configuration files. Use `./setup.sh --dry-run`
to preview the actions without modifying any files.

## Automated Installation

An install script is provided for Arch Linux systems. It installs the packages
listed in `packages/arch.txt` and `packages/aur.txt` and then runs
`setup.sh`.

```bash
./install.sh        # Install packages and configure
./install.sh --dry-run  # Preview actions without making changes
```

## Neovim
`nvim-dap` launches `gdb` by default when debugging C or C++. On Linux the
command `gdb` is used directly. Windows users can fall back to a MinGW
installation (for example `C:\mingw64\bin\gdb.exe`).
The `GDB_PATH` environment variable overrides the executable path on any
platform.

## License
This project is dual-licensed under the MIT License or the Unlicense. See [LICENSE](LICENSE) for details.

## Testing

Install [Bats](https://github.com/bats-core/bats-core) and run the tests from the
repository root:

```bash
bats tests
```

The `tests/` folder also contains a `shellcheckrc` configuration which can be
passed to ShellCheck via `--shellcheckrc tests/shellcheckrc`.
