# shellcheck shell=bash            # Tell ShellCheck this is a Bash script
# ~/.bashrc                        # Personal interactive-shell startup file

[[ $- != *i* ]] && return          # Exit early if the shell is non-interactive

# ── Load shared helper functions ───────────────────────────────────────────────
if [ -f "$HOME/.config/lib/shared.sh" ]; then  # If shared lib exists…
# shellcheck source="/home/liquidscroll/.config/lib/shared.sh"
  . "$HOME/.config/lib/shared.sh"              # …source it
else
  echo "Shared bash library at $HOME/.config/lib/shared.sh not found."  # Warn if missing
fi

# ── Shell options ─────────────────────────────────────────────────────────────
shopt -s histappend checkwinsize    # Append to history & fix line-wrapping resize
set -o noclobber                    # Prevent accidental file overwrite with >

# ── History configuration ─────────────────────────────────────────────────────
HISTCONTROL=ignoreboth:erasedups    # Skip dupes/leading-space cmds & erase dups
HISTSIZE=10000                      # Lines kept in memory
HISTFILESIZE=20000                  # Lines kept on disk

# Truncate any history entry longer than 500 chars
__truncate_history_if_needed() {
  local last id cmd
  last=$(history 1)                 # Get last history entry
  id=${last%% *}                    # Extract entry ID
  cmd=${last#* }                    # Extract full command
  (( ${#cmd} > 500 )) && {          # If command too long…
    history -d "$id"                # …delete old entry
    history -s "${cmd:0:500}"       # …re-add trimmed entry
  }
}

# Run history sync + truncation before each prompt
PROMPT_COMMAND="history -a; history -n; __truncate_history_if_needed${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

# ── Path tweaks ───────────────────────────────────────────────────────────────
add_paths "$HOME/.cache/.bun/bin"    # Add Bun’s cached binaries to PATH

# ── Aliases ───────────────────────────────────────────────────────────────────
alias ls='ls --color=auto -F --group-directories-first'  # Color + mark + group dirs
alias ll='ls -lh'                                        # Long list, human sizes
alias la='ls -A'                                         # Show hidden files
alias cp='cp -i'                                         # Prompt before overwrite
alias mv='mv -i'                                         # Prompt before move
alias rm='rm -i'                                         # Prompt before delete

# Image and search helpers
command -v timg >/dev/null && \
  alias ils='timg --grid=4x2 --upscale --center --title' # Image grid preview

command -v rg   >/dev/null && alias grep='rg'            # Use ripgrep for grep
command -v nvimpager >/dev/null && export PAGER=nvimpager  # Use nvimpager as pager

# ── FZF configuration ─────────────────────────────────────────────────────────
if command -v fzf >/dev/null; then
    # Default file list: include hidden, exclude .git & node_modules
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!{.git,node_modules}/*"'
    if command -v bat >/dev/null; then
        # Preview with bat if available
        export FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}' --bind 'f3:toggle-preview'"
    else
        # Fallback preview with head
        export FZF_DEFAULT_OPTS="--preview 'head -n 200 {}' --bind 'f3:toggle-preview'"
    fi
fi

# ── Extra prompt/history utilities ────────────────────────────────────────────
command -v atuin >/dev/null && eval "$(atuin init bash --disable-up-arrow)" # Atuin history
eval "$(starship init bash)"            # Starship prompt
