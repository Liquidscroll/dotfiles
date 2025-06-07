#!/usr/bin/env fish

function get_hyprspace_workspaces
    set wspaces_json (hyprctl -j workspaces)
    set monitors_json (hyprctl -j monitors)

    set active_ws_map (echo "$monitors_json" | jq 'map({key: .name, value: .activeWorkspace.id}) | from_entries')
    set focused_ws_id (echo "$monitors_json" | jq -r '.[] | select(.focused == true) | .activeWorkspace.id // "null"')

    echo "$wspaces_json" | jq -c \
        --argjson active_ws_map "$active_ws_map" \
        --argjson focused_ws_id "$focused_ws_id" \
        '[ .[] | { id: .id, name: .name, monitor: .monitor, windows: .windows, visible: (.id == ($active_ws_map[.monitor] // false)), focused: (.id == ($focused_ws_id // false)) } ] | reduce .[] as $item ({}; .[$item.monitor] += [$item]) | map_values(sort_by(.id))'
end

function event_stream
    if not command -v socat > /dev/null
        echo "[ERROR] socat command not found" >&2
        return 1
    end

    set hyprland_sig $HYPRLAND_INSTANCE_SIGNATURE
    set default_sock "$XDG_RUNTIME_DIR/hypr/.socket2.sock"

    if test -n "$hyprland_sig"
        set sock_path "$XDG_RUNTIME_DIR/hypr/$hyprland_sig/.socket2.sock"
    else
        set sock_path $default_sock
    end

    if test ! -S $sock_path -a -S $default_sock
        set sock_path $default_sock
    end

    if not test -S $sock_path
        echo "[ERROR] Hyprland event socket not found: $sock_path" >&2
        return 1
    end

    if not socat -u "UNIX-CONNECT:$sock_path" -
        echo "[ERROR] socat failed to connect to event socket: $sock_path" >&2
        return 1
    end
end

set output (get_hyprspace_workspaces)
echo "$output"

event_stream | while read -l _event_line
    if not set output (get_hyprspace_workspaces)
        echo "[ERROR] Failed to generate workspace/monitor data." >&2
        continue
    end
    echo "$output"
end
