# ~/.config/fish/config.fish - generated from dotfiles

# Source shared fish library
if test -f "$HOME/.config/lib/shared.fish"
    source "$HOME/.config/lib/shared.fish"
else
    echo "Shared fish library at $HOME/.config/lib/shared.fish not found."
end

# History size
set -U fish_history 10000

# Truncate extremely long commands (>500 characters) so they do not clutter
# the history file. Capture the command before execution and replace it after
# it runs if needed.
function __capture_last_cmd --on-event fish_preexec
    set -g __last_cmd $argv
end

function __truncate_history_if_needed --on-event fish_postexec
    if test (string length -- "$__last_cmd") -gt 500
        history delete --exact "$__last_cmd"
        history add -- (string sub -l 500 -- "$__last_cmd")
    end
end

# Add common paths
add_paths "$HOME/.local/bin" "$HOME/.cache/.bun/bin"

# Aliases
alias ls "ls --color=auto -F --group-directories-first"
alias ll "ls -lh"
alias la "ls -A"
alias cp "cp -i"
alias mv "mv -i"
alias rm "rm -i"

# Pager configuration
if command_exists nvimpager
    set -gx PAGER nvimpager
else
    set -gx PAGER less
end

# FZF configuration
if command_exists fzf
    set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!{.git,node_modules}/*"'
end
if command_exists bat
    set -gx FZF_DEFAULT_OPTS "--preview 'bat --style=numbers --color=always --line-range :500 {}' --bind 'f3:toggle-preview'"
else
    set -gx FZF_DEFAULT_OPTS "--preview 'head -n 200 {}' --bind 'f3:toggle-preview'"
end

# start ssh agent
ssh-agent -c | source

if command_exists atuin
    atuin init fish --disable-up-arrow | source
end

# starship prompt
starship init fish | source
