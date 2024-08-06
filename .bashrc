# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#if [ -f "$HOME/.profile" ]; then
#    source "$HOME/.profile"
#fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/liquidscroll/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/liquidscroll/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/liquidscroll/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/liquidscroll/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
#unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi




#export PATH="/home/liquidscroll/.splashkit:$PATH"
#eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#source ~/.profile

#eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#eval "$(oh-my-posh init bash --config ~/half-life.omp.json)"
#exec bash
#eval "$(/bin/brew shellend)"
#export PATH="/home/liquidscroll/.splashkit:$PATH"
#export PATH="/home/liquidscroll/.splashkit:$PATH"

load_colors_from_json()
{
	#local json_file="$HOME/shell_colours.json"
	local json_file="/home/liquidscroll/shell_colours.json"
	
	if [[ -f "$json_file" ]]; then
        BG_COLOR="\[$(jq -r '.bg_color' "$json_file")\]"
        FG_COLOR="\[$(jq -r '.fg_color' "$json_file")\]"
        BLACK="\[$(jq -r '.black' "$json_file")\]"
        RED="\[$(jq -r '.red' "$json_file")\]"
        GREEN="\[$(jq -r '.green' "$json_file")\]"
        YELLOW="$(jq -r '.yellow' "$json_file")"
        BLUE="\[$(jq -r '.blue' "$json_file")\]"
        MAGENTA="\[$(jq -r '.magenta' "$json_file")\]"
        CYAN="\[$(jq -r '.cyan' "$json_file")\]"
        WHITE="\[$(jq -r '.white' "$json_file")\]"
        RESET="$(jq -r '.reset' "$json_file")"
    else
        echo "JSON file with color definitions not found!"
    fi
}

load_colors_from_json

GIT_SYMBOL=$'\ue725' # nerd font symbol for GIT
USER_ID=$(id -u) # check for root

get_git_branch() 
{ 
	git branch 2>/dev/null | grep '^*' | sed 's/* //' #| colrm 1 2 
}

if [ "$color_prompt" = yes ]; then
	if [ "$USER_ID" -eq 0 ]; then
		PS1="${FG_COLOR}@root" # @username:root
	else
		PS1="${FG_COLOR}@\u" # @username
	fi
	#PS1="${FG_COLOR}@\u"    # Username
    PS1+="${RESET} ${BLUE}\w${RESET}"                   # Current working directory
	PS1+='$(git_branch=$(get_git_branch); if [ -n "$git_branch" ]; then echo -e "\n${YELLOW}${GIT_SYMBOL} $git_branch${RESET}"; fi)' # Current git branch
	if [ "$USER_ID" -eq 0 ]; then
		PS1+="${GREEN}\n#\[${RESET}\] "
	else
		PS1+="${GREEN}\n\$\[${RESET}\] "
	fi
else
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

export PATH="/home/liquidscroll/.splashkit:$PATH"
