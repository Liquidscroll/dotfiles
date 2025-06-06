#!/usr/bin/env bash

source "${HOME}/.config/lib/shared.sh"

_DEBUG=false
_IS_SPEAKER=true
_SPEAKER_SYMBOL=""
_SPEAKER_SYMBOL_MUTE=""
_HEADSET_SYMBOL="󰋋"
_HEADSET_SYMBOL_MUTE="󰟎"
_EWW_CONFIG_PATH="${HOME}/.config/eww/"

function get_all_sinks() {
    local output
    output=$(wpctl status)
    echo "$output" | awk '
    BEGIN { in_sinks=0 }
    /Sinks:/ { in_sinks=1; next }
    /Sources:/ { exit }
    in_sinks && NF > 0 {
        match($0, /.?([0-9]+)\. (.*)\[/, arr);
        gsub(/ /, "", arr[2]);
        if(arr[2] == "") exit;
        printf "%d | %s\n", arr[1], arr[2];
    }
    '
}

function is_speaker() {
    local sink_name
    sink_name=$(wpctl inspect @DEFAULT_SINK@ | grep node.description | awk -F'= ' '{gsub(/"/, ""); print $NF}')
    debug "Default sink description: $sink_name"
    if [[ -n "$sink_name" ]]; then
        if [[ "$sink_name" == "LogitechSpeakers" ]]; then
            return 0
        else
            return 1
        fi
    else
        echo "[ERROR] Could not determine default sink name."
    fi
}

function set_mute_symbol() {
    local set_muted=$1 # true or false
    local icon_to_set
    if is_speaker; then
        if [[ $set_muted == true ]]; then
            icon_to_set=$_SPEAKER_SYMBOL_MUTE
        else
            icon_to_set=$_SPEAKER_SYMBOL
        fi
    else
        if [[ $set_muted == true ]]; then
            icon_to_set=$_HEADSET_SYMBOL_MUTE
        else
            icon_to_set=$_HEADSET_SYMBOL
        fi
    fi
    eww -c "$_EWW_CONFIG_PATH" update "audio_sink_icon=${icon_to_set}"
    debug "Updated mute icon to $icon_to_set"
}

function command_mute() {
    debug "Toggling mute status"
    # toggle mute on default sink
    wpctl set-mute @DEFAULT_SINK@ toggle
    # get mute status
    # if muted will contain MUTED
    if wpctl get-volume @DEFAULT_SINK@ | grep -q MUTED; then
        set_mute_symbol true
    else
        set_mute_symbol false
    fi
}

function command_menu() {
    local sinks
    sinks=$(get_all_sinks)
    debug "Listing available sinks"

    local selected_sink
    selected_sink=$(echo "$sinks" | tofi --prompt-text="Audio Devices:" --width=600 --height=400   \
    debug "Selected sink entry: $selected_sink"
        --hide-input=true --hidden-character= --padding-top=20      \
        --padding-bottom=20 --corner-radius=10 --padding-right=100 \
        --margin-left=0)

    wpctl set-default "$(echo "$selected_sink" | cut -d'|' -f1)"

}

function get_volume_percent() {
    local volume
    volume=$(wpctl get-volume @DEFAULT_SINK@)
    echo "$volume" | awk '{print $2 * 100}'
}

function command_volume() {
    debug "Starting volume monitor"
    local last_vol=""
    while true; do
        local vol
        vol=$(get_volume_percent)
        if [[ "$vol" != "$last_vol" ]]; then
            echo "$vol"
            debug "Volume changed to $vol"
            last_vol=$vol
        fi
        sleep 0.3
    done
}

# Start of scripts

if [[ "$1" == "--debug" ]] || [[ "$1" == "-d" ]]; then
    _DEBUG=true
    info "Debug mode enabled."
    shift
fi

COMMAND="${1:-}"


if [[ -z "$COMMAND" ]]; then
    echo "Usage: $0 [--debug|-d] <command> [command_args...]"
    echo "Available commands:"
    echo "  volume                Continuously monitors and prints volume percentage."
    echo "  mute                  Toggles mute status of the default sink and updates Eww icon."
    echo "  menu                  Displays a Tofi menu to select the default audio sink."
    exit 1
fi

shift # Remove the command itself from arguments, leaving only its parameters

# Ensure wpctl exists
if ! command_exists "wpctl" && [[ "$COMMAND" != "help" && "$COMMAND" != "" ]]; then
    error "wpctl command not found. Please install wireplumber."
    exit 1
fi

# Command Dispatch
case "$COMMAND" in
    volume)
        command_volume "$@"
        ;;
    mute)
        command_mute "$@"
        ;;
    menu)
        command_menu "$@"
        ;;
    *)
        error "Unknown command: $COMMAND"
        exit 1
        ;;
esac

exit 0
