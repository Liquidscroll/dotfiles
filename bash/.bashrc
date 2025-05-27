#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source shared funcs.
if [ -f "$HOME/.config/lib/shared.sh" ]; then
    source "$HOME/.config/lib/shared.sh"
else
    echo "Shared bash library at $HOME/.config/lib/shared.sh not found."
fi

HISTCONTROL=ignoreboth:erasedups # ignoreboth (ignoredups & ignorespace), erasedups (better than ignoredups)
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend # Append to the history file, don't overwrite it

# Save and reload history after each command and before displaying the prompt
# This ensures history is shared across terminal sessions and saved immediately.
# Prepend to existing PROMPT_COMMAND in case other tools (like Starship) also use it.
#PROMPT_COMMAND="history -a; history -n${PROMPT_COMMAND:+;$PROMPT_COMMAND}"


add_paths "$HOME/.local/bin"
# --- Aliases ---
# General ls
alias ls='ls --color=auto -F --group-directories-first'
alias ll='ls -lh'
alias la='ls -A' # Show hidden files

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Prevent shell redirection overwriting files
# note: use |> to overwrite instead of >
set -o noclobber

if command_exists rg; then
    alias grep='rg'
fi

if command_exists nvimpager; then
    export PAGER="nvimpager"
else
    export PAGER="less"
fi

if command_exists fzf; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!{.git,node_modules}/*"'
fi

if command_exists bat; then
    export FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}' --bind 'f3:toggle-preview'"
else
    # Fallback FZF_DEFAULT_OPTS if bat is not available
    export FZF_DEFAULT_OPTS="--preview 'head -n 200 {}' --bind 'f3:toggle-preview'"
fi


[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# start ssh agent
eval "$(ssh-agent)"

# start starship
eval "$(starship init bash)"
