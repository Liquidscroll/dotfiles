#!/usr/bin/env bash

# Global script to run install or setup in chosen shell. Multiple
# shells can be specified in a comma separated list.

ACTION=""
SHELL_TYPE="bash"
DRY_RUN=""

usage() {
    echo "Usage: $0 <install|setup> [--shell bash|fish|bash,fish] [--dry-run]" >&2
    exit 1
}

if [[ $# -eq 0 ]]; then
    usage
fi

ACTION="$1"
shift

while [[ $# -gt 0 ]]; do
    case "$1" in
        --shell)
            SHELL_TYPE="$2"
            shift
            ;;
        --dry-run|-n)
            DRY_RUN="--dry-run"
            ;;
        *)
            usage
            ;;
    esac
    shift
done

case "$ACTION" in
    install|setup)
        ;;
    *)
        usage
        ;;
esac

if [[ "$SHELL_TYPE" == *","* ]]; then
    IFS=',' read -ra _shells <<< "$SHELL_TYPE"
    _bash=false
    _fish=false
    for s in "${_shells[@]}"; do
        case "$s" in
            bash) _bash=true ;;
            fish) _fish=true ;;
        esac
    done
    if [[ $_bash == true && $_fish == true ]]; then
        SHELL_TYPE="bash"
    elif [[ $_fish == true ]]; then
        SHELL_TYPE="fish"
    else
        SHELL_TYPE="bash"
    fi
fi

SCRIPT="bin/${ACTION}.sh"
if [[ "$SHELL_TYPE" == "fish" ]]; then
    SCRIPT="bin/${ACTION}.fish"
fi

if [[ ! -f "$SCRIPT" ]]; then
    echo "Script not found: $SCRIPT" >&2
    exit 1
fi

if [[ "$SHELL_TYPE" == "fish" ]]; then
    fish "$SCRIPT" $DRY_RUN
else
    bash "$SCRIPT" $DRY_RUN
fi
