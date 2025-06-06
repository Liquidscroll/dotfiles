#!/usr/bin/env bash

function get_hyprspace_workspaces() {
    local wspaces_json monitors_json
    wspaces_json=$(hyprctl -j workspaces)
    monitors_json=$(hyprctl -j monitors)

    # hyprctl exposes workspace and monitor information as JSON.
    # The next steps merge these two sources to build a structure of
    # workspaces grouped by monitor with extra metadata used by the eww
    # widgets.
    #
    # active_ws_map maps monitor name -> active workspace id.
    local active_ws_map
    active_ws_map=$(echo "$monitors_json" | jq 'map({key: .name, value: .activeWorkspace.id}) | from_entries')

    # id of the active workspace on the currently focused monitor
    local focused_ws_id
    focused_ws_id=$(echo "$monitors_json" | jq -r '.[] | select(.focused == true) | .activeWorkspace.id // "null"')


    echo "$wspaces_json" | jq -c\
        --argjson active_ws_map "$active_ws_map" \
        --argjson focused_ws_id "$focused_ws_id" \
        '
        [
            .[] | {
                id: .id,
                name: .name,
                monitor: .monitor,
                windows: .windows,
                visible: (.id == ($active_ws_map[.monitor] // false)),
                focused: (.id == ($focused_ws_id // false))
            }
        ]
        | reduce .[] as $item ({}; .[$item.monitor] += [$item])
        | map_values(sort_by(.id))
        '
}

function event_stream() {
    local hyprland_sig sock_path default_sock

    # Ensure socat is available before attempting to stream events
    if ! command -v socat >/dev/null; then
        echo "[ERROR] socat command not found" >&2
        return 1
    fi

    hyprland_sig="${HYPRLAND_INSTANCE_SIGNATURE:-}"
    default_sock="${XDG_RUNTIME_DIR}/hypr/.socket2.sock"

    if [[ -n "$hyprland_sig" ]]; then
        sock_path="${XDG_RUNTIME_DIR}/hypr/${hyprland_sig}/.socket2.sock"
    else
        sock_path="$default_sock"
    fi

    # Fallback to default socket if derived path doesn't exist
    if [[ ! -S "$sock_path" && -S "$default_sock" ]]; then
        sock_path="$default_sock"
    fi

    if [[ ! -S "$sock_path" ]]; then
        echo "[ERROR] Hyprland event socket not found: $sock_path" >&2
        return 1
    fi

    if ! socat -u "UNIX-CONNECT:$sock_path" - ; then
        echo "[ERROR] socat failed to connect to event socket: $sock_path" >&2
        return 1
    fi


}

output=$(get_hyprspace_workspaces)
echo "$output"

event_stream | while IFS= read -r _event_line; do
    if ! output=$(get_hyprspace_workspaces); then
        echo "[ERROR] Failed to generate workspace/monitor data." >&2
        continue
    fi
    echo "$output"
done

