# ~/.config/fish/config.fish - generated from dotfiles

# Source shared fish library
if test -f "$HOME/.config/lib/shared.fish"
    source "$HOME/.config/lib/shared.fish"
else
    echo "Shared fish library at $HOME/.config/lib/shared.fish not found."
end

# History size
set -U fish_history 10000

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

# starship prompt
starship init fish | source
