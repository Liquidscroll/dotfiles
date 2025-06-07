# Fish utilities similar to shared.sh

function command_exists
    type -q $argv[1]
end

function source_if_exists
    set file $argv[1]
    if test -f $file
        source $file
    else
        echo "Sourcing $file failed, file not found."
    end
end

set -g _symlinks_current_dir (dirname (status --current-filename))
if test -z "$_symlinks_current_dir"
    set -g _symlinks_current_dir (pwd)
end

function dotfiles_location
    realpath $_symlinks_current_dir/..
end

source_if_exists (dotfiles_location)/lib/colours.fish

if not set -q DRY_RUN
    set -g DRY_RUN false
end

function symlink_dotfiles
    set file_rel_path $argv[1]
    set dest $argv[2]

    set src (dotfiles_location)/$file_rel_path
    if not test -e $src
        error "Source does not exist: $src"
        return 1
    end

    if test -d $src -a -d $dest -a ! -L $dest
        set dest $dest/(basename $src)
    end

    set parent_dir (dirname $dest)
    if not test -d $parent_dir
        info "Creating parent directory: $parent_dir"
        if test $DRY_RUN != true
            mkdir -p $parent_dir
        end
    end

    if test $DRY_RUN = true
        info "(dry-run) Would symlink $src -> $dest"
        return 0
    end

    if test -L $dest; and test (readlink $dest) = $src
        info "Already symlinked: $dest -> $src"
        return 0
    end

    if test -e $dest
        error "Destination exists and is: $dest"
        return 1
    end

    info "Symlinking $src -> $dest"
    if ln -s $src $dest
        success "Linked $src -> $dest"
        return 0
    else
        error "Failed to link $src -> $dest"
        return 1
    end
end

function ensure_git_clone
    set repo $argv[1]
    set destination $argv[2]
    if not test -d $destination
        git clone $repo $destination
    end
end

function add_paths
    for d in $argv
        if test -d $d
            if not string match -q ":$d:" ":$PATH:"
                set -gx PATH $PATH $d
            end
        end
    end
end

set -g _current_os (uname)

function is_macos
    test $_current_os = 'Darwin'
end

function is_linux
    test $_current_os = 'Linux'
end

function is_windows
    echo $_current_os | grep -q -E 'MINGW|MSYS|CYGWIN|NT'
end

function is_arch
    test (grep '^ID=' /etc/os-release | cut -d '=' -f2) = 'arch'
end

function is_sudo
    test $EUID -eq 0
end

function is_hyprland
    test "$XDG_CURRENT_DESKTOP" = 'Hyprland'
end

function xdg_config_dir
    if set -q XDG_CONFIG_HOME
        echo $XDG_CONFIG_HOME
    else
        echo "$HOME/.config"
    end
end

function xdg_data_dir
    if set -q XDG_DATA_HOME
        echo $XDG_DATA_HOME
    else
        echo "$HOME/.local/share"
    end
end
