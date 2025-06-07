# Fish equivalent of colours.sh

set -g RESET '\033[0m'
set -g BOLD '\033[1m'

set -g RED '\033[0;31m'
set -g GREEN '\033[0;32m'
set -g YELLOW '\033[0;33m'
set -g BLUE '\033[0;34m'
set -g CYAN '\033[0;36m'
set -g GRAY '\033[0;90m'

set -g TICK "$GREEN✓$RESET"
set -g CROSS "$RED✗$RESET"

function info
    echo -e "$CYAN [INFO]$RESET  $argv"
end

function success
    echo -e "$GREEN   [OK]$RESET    $argv"
end

function warn
    echo -e "$YELLOW [WARN]$RESET  $argv"
end

function error
    echo -e "$RED[ERROR]$RESET $argv" >&2
end

function debug
    if test "$_DEBUG" = true
        echo -e "$GRAY[DEBUG]$RESET $argv"
    end
end
