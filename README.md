# Dotfiles

Contains my configurations for:
- `bash/`
    - `.bashrc` and `bin/setup.sh`
    - Shared functions are found in `lib/shared.sh`
    - Colour definitions and messaging functions are found in `lib/colours.sh`
- `fish/`
    - `config.fish` and `bin/setup.fish`
    - Fish utilities are in `lib/shared.fish` and `lib/colours.fish`
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
Run `./dotfiles.sh setup --shell bash` to symlink the configuration files using Bash or `--shell fish` for Fish. You can pass multiple shells as a comma separated list (for example `--shell bash,fish`). When both shells are specified the Bash script is used.
Use the `--dry-run` flag to preview the actions without modifying any files.

## Automated Installation

An install script is provided for Arch Linux systems. It installs the packages
listed in `packages/arch.txt` and `packages/aur.txt` and then runs the
appropriate setup script.

```bash
./dotfiles.sh install --shell bash        # Install packages and configure using Bash
./dotfiles.sh install --shell bash,fish  # Install using Bash when both shells are requested
./dotfiles.sh install --shell fish --dry-run  # Preview actions without making changes using Fish
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

Tests are executed inside a Docker container based on Arch Linux. To run them
locally, ensure Docker is installed and then execute:

```bash
./scripts/run-tests.sh
```

This script builds the container defined in the `Dockerfile` and runs `bats`.
The same container is used in continuous integration and will be executed
automatically on every push or pull request.

The `tests/` folder also contains a `shellcheckrc` configuration which can be
passed to ShellCheck via `--shellcheckrc tests/shellcheckrc`.
