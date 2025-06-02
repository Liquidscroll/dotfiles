#!/usr/bin/env bash
#
#  ensure-single-window.sh  ── focus an existing Hyprland window of CLASS,
#                             or start COMMAND if none exists.
#
#  Usage:
#     ensure-single-window.sh <class> <command…>
#  Example:
#     ensure-single-window.sh clipse \
#         wezterm cli spawn --new-window --class clipse -- clipse
#
#  Requires:
#     hyprctl (from Hyprland) and jq (for JSON filtering).

set -euo pipefail

if (( $# < 2)); then
    echo "Usage: $0 <class> <command...>" >&2
    exit 1
fi

CLASS="$1"
shift

if hyprctl -j clients | jq -e ".[] | select(.class == \"$CLASS\")" >/dev/null; then
    curr_ws=$(hyprctl -j activeworkspace | jq '.id') 
    echo "curr ws: $curr_ws"
    hyprctl dispatch focuswindow "class:$CLASS"
    hyprctl dispatch movetoworkspace "$curr_ws"
else
    "$@" &
fi

