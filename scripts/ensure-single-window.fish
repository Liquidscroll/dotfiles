#!/usr/bin/env fish
# focus an existing Hyprland window of CLASS or start COMMAND if none exists

if test (count $argv) -lt 2
    echo "Usage: $argv[0] <class> <command...>" >&2
    exit 1
end

set CLASS $argv[1]
set argv $argv[2..-1]

if hyprctl -j clients | jq -e ".[] | select(.class == \"$CLASS\")" >/dev/null
    set curr_ws (hyprctl -j activeworkspace | jq '.id')
    hyprctl dispatch focuswindow "class:$CLASS"
    hyprctl dispatch movetoworkspace "$curr_ws"
else
    eval $argv &
end
