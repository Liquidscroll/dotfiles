#!/usr/bin/env fish

source "$HOME/.config/lib/shared.fish"

set -g _DEBUG false
set -g _IS_SPEAKER true
set -g _SPEAKER_SYMBOL ""
set -g _SPEAKER_SYMBOL_MUTE ""
set -g _HEADSET_SYMBOL "󰋋"
set -g _HEADSET_SYMBOL_MUTE "󰟎"
set -g _EWW_CONFIG_PATH "$HOME/.config/eww/"

function get_all_sinks
    set output (wpctl status)
    echo "$output" | awk '
    BEGIN { in_sinks=0 }
    /Sinks:/ { in_sinks=1; next }
    /Sources:/ { exit }
    in_sinks && NF > 0 {
        match($0, /.?([0-9]+)\. (.*)\[/, arr);
        gsub(/ /, "", arr[2]);
        if(arr[2] == "") exit;
        printf "%d | %s\n", arr[1], arr[2];
    }'
end

function is_speaker
    set sink_name (wpctl inspect @DEFAULT_SINK@ | grep node.description | awk -F'=' '{gsub(/"/, ""); print $NF}')
    debug "Default sink description: $sink_name"
    if test -n "$sink_name"
        if test "$sink_name" = "LogitechSpeakers"
            return 0
        else
            return 1
        end
    else
        echo "[ERROR] Could not determine default sink name."
    end
end

function set_mute_symbol
    set set_muted $argv[1]
    set icon_to_set
    if is_speaker
        if test $set_muted = true
            set icon_to_set $_SPEAKER_SYMBOL_MUTE
        else
            set icon_to_set $_SPEAKER_SYMBOL
        end
    else
        if test $set_muted = true
            set icon_to_set $_HEADSET_SYMBOL_MUTE
        else
            set icon_to_set $_HEADSET_SYMBOL
        end
    end
    eww -c $_EWW_CONFIG_PATH update "audio_sink_icon=$icon_to_set"
    debug "Updated mute icon to $icon_to_set"
end

function command_mute
    debug "Toggling mute status"
    wpctl set-mute @DEFAULT_SINK@ toggle
    if wpctl get-volume @DEFAULT_SINK@ | grep -q MUTED
        set_mute_symbol true
    else
        set_mute_symbol false
    end
end

function command_menu
    set sinks (get_all_sinks)
    debug "Listing available sinks"
    set selected_sink (echo "$sinks" | tofi --prompt-text="Audio Devices:" --width=600 --height=400 \
        --hide-input=true --hidden-character= --padding-top=20 \
        --padding-bottom=20 --corner-radius=10 --padding-right=100 \
        --margin-left=0)
    debug "Selected sink entry: $selected_sink"
    wpctl set-default (echo "$selected_sink" | cut -d'|' -f1)
end

function get_volume_percent
    set volume (wpctl get-volume @DEFAULT_SINK@)
    echo "$volume" | awk '{print $2 * 100}'
end

function command_volume
    debug "Starting volume monitor"
    set last_vol ""
    while true
        set vol (get_volume_percent)
        if test "$vol" != "$last_vol"
            echo "$vol"
            debug "Volume changed to $vol"
            set last_vol $vol
        end
        sleep 0.3
    end
end

if test "$argv[1]" = "--debug" -o "$argv[1]" = "-d"
    set _DEBUG true
    info "Debug mode enabled."
    set argv $argv[2..-1]
end

set COMMAND $argv[1]
set argv $argv[2..-1]

if test -z "$COMMAND"
    echo "Usage: $argv[0] [--debug|-d] <command> [command_args...]"
    echo "Available commands:"
    echo "  volume    Continuously monitors and prints volume percentage."
    echo "  mute      Toggles mute status of the default sink and updates Eww icon."
    echo "  menu      Displays a Tofi menu to select the default audio sink."
    exit 1
end

if not command_exists wpctl
    if test "$COMMAND" != "help" -a "$COMMAND" != ""
        error "wpctl command not found. Please install wireplumber."
        exit 1
    end
end

switch $COMMAND
    case volume
        command_volume $argv
    case mute
        command_mute $argv
    case menu
        command_menu $argv
    case '*'
        error "Unknown command: $COMMAND"
        exit 1
end
