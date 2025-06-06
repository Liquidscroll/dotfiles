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
- Spotify launcher: `spotify-launcher.conf`
- Starship prompt: `starship.toml`


At the moment this is a WIP and is intended to only be used on Arch Linux.
Before running, ensure pacman is upgraded with `pacman -Syu`

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
